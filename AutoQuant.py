# @title # ⚡ AutoQuant

# @markdown > 🗣️ [Large Language Model Course](https://github.com/mlabonne/llm-course)

# @markdown ❤️ Created by [@maximelabonne](https://twitter.com/maximelabonne).

# @markdown **Usage:** Download the model by **running this cell** and then run the cells corresponding to your quantization methods of interest.

# @markdown To quantize a 7B or 8B model, GGUF only needs a T4 GPU, while the other methods require an L4 or A100 GPU.

# @markdown ---

# @markdown ## 🤗 Download model (required)
# @markdown `MODEL_ID` is the ID of the model to quantize on the Hugging Face hub.
MODEL_ID = "LiquidAI/LFM2.5-350M" # @param {type:"string"}

# @markdown `USERNAME` is your username on Hugging Face.
USERNAME = "mlabonne" # @param {type:"string"}

# @markdown `HF_TOKEN` corresponds to the name of the secret that stores your [Hugging Face access token](https://huggingface.co/settings/tokens) in Colab.
HF_TOKEN = "HF_TOKEN" # @param {type:"string"}

MODEL_NAME = MODEL_ID.split('/')[-1]

!pip install -qqq huggingface_hub --progress-bar off
!pip install -qqq -U numpy==1.23.5 transformers --progress-bar off

from huggingface_hub import create_repo, HfApi, ModelCard, snapshot_download
from google.colab import userdata, runtime
import shutil
import fnmatch
import os

# Defined in the secrets tab in Google Colab
hf_token = userdata.get(HF_TOKEN)
api = HfApi()

# Download model using huggingface_hub
model_path = snapshot_download(
    repo_id=MODEL_ID,
    token=hf_token,
    ignore_patterns=["*.msgpack", "*.h5", "*.ot", "*.onnx"],  # Ignore certain file types
    local_dir=MODEL_NAME
)
print(f"Model downloaded to: {model_path}")

def upload_quant(base_model_id, quantized_model_name, quantization_type, save_folder, allow_patterns=None, bpw=None):
    """
    Create a model card (if necessary), upload the quantized model to Hugging Face.

    :param base_model_id: The ID of the base model
    :param quantized_model_name: The name for the quantized model
    :param quantization_type: The type of quantization (e.g., 'gguf', 'gptq', 'awq', 'hqq', 'exl2')
    :param save_folder: The folder where the quantized model is saved
    :param allow_patterns: List of file patterns to upload (default is None, which uploads all files)
    :param bpw: Bits per weight (used for EXL2 quantization)
    """
    # Initialize Hugging Face API
    api = HfApi()

    # Define the repository ID for the quantized model
    if quantization_type == 'exl2':
        repo_id = f"{USERNAME}/{quantized_model_name}-{bpw:.1f}bpw-exl2"
    else:
        repo_id = f"{USERNAME}/{quantized_model_name}"

    # Try to load existing model card
    try:
        existing_card = ModelCard.load(repo_id)
        print(f"Model card already exists for {repo_id}. Skipping model card creation.")
    except Exception:
        # If the model card doesn't exist, create a new one
        card = ModelCard.load(base_model_id)
        card.data.tags = [] if card.data.tags is None else card.data.tags
        card.data.tags.append("autoquant")
        card.data.tags.append(quantization_type)
        card.save(f'{save_folder}/README.md')
        print(f"Created new model card for {repo_id}")

    # Create or update the repository
    create_repo(
        repo_id=repo_id,
        repo_type="model",
        exist_ok=True,
        token=hf_token
    )

    # Upload the model
    api.upload_folder(
        folder_path=save_folder,
        repo_id=repo_id,
        allow_patterns=allow_patterns,
        token=hf_token
    )

    print(f"Uploaded quantized model to {repo_id}")
