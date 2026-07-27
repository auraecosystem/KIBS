Here is the complete, updated code combining the clean formatting with the original functionality:
```python
# @title # 🦙 ExLlamaV2 Quantization
# @markdown Learn more about ExLlamaV2 in [this article](https://mlabonne.github.io/blog/posts/ExLlamaV2_The_Fastest_Library_to_Run%C2%A0LLMs.html).

# --- Configuration ---
BPW = 4.5  # @param {type:"number"} Target Bits Per Weight

# --- 1. Install ExLlamaV2 ---
!git clone https://github.com/turboderp/exllamav2
!pip install -e exllamav2

# --- 2. Prepare Base Model Directory ---
!cp -r {MODEL_NAME} base_model
!rm -f base_model/*.bin

# --- 3. Download Calibration Dataset ---
!wget https://huggingface.co/datasets/wikitext/resolve/9a9e482b5987f9d25b3a9b2883fc6cc9fd8071b3/wikitext-103-v1/wikitext-test.parquet

# --- 4. Quantize Model ---
save_folder = f"{MODEL_ID}-EXL2"
!mkdir -p {save_folder}

!python exllamav2/convert.py \
    -i base_model \
    -o {save_folder} \
    -c wikitext-test.parquet \
    -b {BPW}

# --- 5. Copy Configuration & Tokenizer Files ---
!rm -rf quant/out_tensor
!rsync -av --exclude='*.safetensors' --exclude='.*' base_model/ {save_folder}/

# --- 6. Upload Quantized Model ---
upload_quant(
    base_model_id=MODEL_ID,
    quantized_model_name=MODEL_NAME,
    quantization_type="exl2",
    save_folder=save_folder,
    bpw=BPW
)

```
