# @title ## 🧩 GGUF

# @markdown Recommended methods: `q2_k`, `q3_k_m`, `q4_k_m`, `q5_k_m`, `q6_k`, `q8_0`

# @markdown Imatrix methods: `IQ3_M`, `IQ3_XXS`, `Q4_K_M`, `Q4_K_S`, `IQ4_NL`, `IQ4_XS`, `Q5_K_M`, `Q5_K_S`

# @markdown Learn more about GGUF and quantization methods in [this article](https://mlabonne.github.io/blog/posts/Quantize_Llama_2_models_using_ggml.html). This implementation is based on the excellent [gguf-my-repo](https://huggingface.co/spaces/ggml-org/gguf-my-repo).

# @markdown ---

import os
import subprocess
import signal
from pathlib import Path

# @markdown Choose quantization methods (comma-separated)
QUANTIZATION_FORMAT = "q2_k, q3_k_m, q4_k_m, q5_k_m, q6_k, q8_0" # @param {type:"string"}
# @markdown Split large models into multiple files?
SPLIT_MODEL = False # @param {type:"boolean"}
# @markdown Maximum number of tensors per file when splitting (only used if `SPLIT_MODEL` is True)
SPLIT_MAX_TENSORS = 256 # @param {type:"integer"}
# @markdown Use importance matrix for better quantization?
USE_IMATRIX = False # @param {type:"boolean"}
# @markdown Path to custom training data for imatrix (leave empty to use default)
TRAIN_DATA_PATH = "" # @param {type:"string"}

# Parse quantization methods
QUANTIZATION_METHODS = [q.strip() for q in QUANTIZATION_FORMAT.replace(" ", "").split(",")]
gguf_repo_id = f"{USERNAME}/{MODEL_NAME}-GGUF"

# Clone and build llama.cpp with CMake if it doesn't exist
if not os.path.exists("llama.cpp"):
    !git clone https://github.com/ggerganov/llama.cpp
    !cd llama.cpp && cmake -B build && cmake --build build --config Release
    !pip install -r llama.cpp/requirements.txt

def generate_importance_matrix(model_path, train_data_path, output_path):
    """Generate importance matrix for better quantization."""
    print(f"Generating importance matrix...")

    if not os.path.isfile(model_path):
        raise Exception(f"Model file not found: {model_path}")

    # Use default calibration dataset if none provided
    if not train_data_path or not os.path.isfile(train_data_path):
        print("Using default calibration dataset...")
        train_data_path = "llama.cpp/groups_merged.txt"

    # Command to generate importance matrix - use build directory
    imatrix_command = [
        "./llama.cpp/build/bin/llama-imatrix",
        "-m", model_path,
        "-f", train_data_path,
        "-ngl", "99",
        "--output-frequency", "10",
        "-o", output_path,
    ]

    # Run the command with timeout handling
    process = subprocess.Popen(imatrix_command, shell=False)
    try:
        process.wait(timeout=600)  # 10 minute timeout
    except subprocess.TimeoutExpired:
        print("Imatrix computation timed out. Sending SIGINT to allow graceful termination...")
        process.send_signal(signal.SIGINT)
        try:
            process.wait(timeout=5)  # grace period
        except subprocess.TimeoutExpired:
            print("Imatrix process still didn't terminate. Forcefully terminating...")
            process.kill()

    if os.path.exists(output_path):
        print(f"Importance matrix generated successfully at {output_path}")
    else:
        raise Exception("Failed to generate importance matrix")

def split_model_into_shards(model_path, split_max_tensors):
    """Split a large model into multiple smaller files."""
    print(f"Splitting model {model_path} into shards...")

    model_path_prefix = '.'.join(model_path.split('.')[:-1])  # remove file extension

    split_cmd = [
        "./llama.cpp/build/bin/llama-gguf-split",
        "--split",
        "--split-max-tensors", str(split_max_tensors),
        model_path,
        model_path_prefix
    ]

    result = subprocess.run(split_cmd, shell=False, capture_output=True, text=True)

    if result.returncode != 0:
        raise Exception(f"Error splitting the model: {result.stderr}")

    print("Model split successfully!")

    # Get list of sharded files
    model_file_prefix = os.path.basename(model_path_prefix)
    sharded_files = [f for f in os.listdir(os.path.dirname(model_path))
                     if f.startswith(model_file_prefix) and f.endswith(".gguf")]

    if not sharded_files:
        raise Exception("No sharded files found after splitting")

    print(f"Created {len(sharded_files)} shards: {sharded_files}")

    # Remove the original model file to save space
    if os.path.exists(model_path):
        os.remove(model_path)
        print(f"Removed original model file {model_path}")

    return sharded_files

# Create output directories
os.makedirs(MODEL_NAME, exist_ok=True)

# Convert to FP16/BF16 first (using fp16 as in the HF implementation)
out = f"{MODEL_NAME}/{MODEL_NAME.lower()}.fp16.gguf"
if os.path.exists(out):
    print(f"File {out} already exists. Skipping conversion.")
else:
    print("Converting model to FP16 format...")
    !python llama.cpp/convert_hf_to_gguf.py {MODEL_NAME} --outtype f16 --outfile {out}

# Generate importance matrix if requested
imatrix_path = f"{MODEL_NAME}/imatrix.dat"
if USE_IMATRIX:
    if not os.path.exists(imatrix_path):
        generate_importance_matrix(out, TRAIN_DATA_PATH, imatrix_path)
    else:
        print(f"Importance matrix already exists at {imatrix_path}")

# Quantize the model for each method
for method in QUANTIZATION_METHODS:
    quant_suffix = f"{method.lower()}-imat" if USE_IMATRIX else method.lower()
    quant_path = f"{MODEL_NAME}/{MODEL_NAME.lower()}.{quant_suffix}.gguf"

    # Skip if already exists
    if os.path.exists(quant_path):
        print(f"Quantized model {quant_path} already exists, skipping...")
        continue

    print(f"Quantizing model with {method}...")
    if USE_IMATRIX:
        !./llama.cpp/build/bin/llama-quantize --imatrix {imatrix_path} {out} {quant_path} {method}
    else:
        !./llama.cpp/build/bin/llama-quantize {out} {quant_path} {method}

    # Split the model if requested
    if SPLIT_MODEL and os.path.exists(quant_path):
        split_model_into_shards(quant_path, SPLIT_MAX_TENSORS)

    # Upload using existing upload_quant function
    upload_quant(
        base_model_id=MODEL_ID,
        quantized_model_name=f"{MODEL_NAME}-GGUF",
        quantization_type="gguf",
        save_folder=MODEL_NAME,
        allow_patterns=["*.gguf", "*.md", "imatrix.dat"] if USE_IMATRIX else ["*k.gguf", "*m.gguf","*0.gguf", "*.md"]
    )

print("✅ GGUF quantization completed successfully!")
