### ⚡ Quick Start & Deployment Guide

#### 1. 📂 Hugging Face Setup & Download
* Enter the **`MODEL_ID`** of any model from the Hugging Face Hub (e.g., `meta-llama/Llama-2-7b-hf` or `LiquidAI/LFM2.5-350M`).
* Enter your Hugging Face **`USERNAME`** to upload converted or quantized weights back to your profile.
* Run the setup cell to download model weights.

---

#### 2. ⚡ Quantization & Model Optimization
Execute the cell corresponding to your desired quantization format:
* **GGUF** | **GPTQ** | **ExLlamaV2** | **AWQ** | **HQQ**

> 💡 **GPU Requirements:**
> * **GGUF** (7B–8B models): Runs on a free **T4 GPU**.
> * **Larger Models & Other Formats:** Require an **L4** or **A100 GPU**.

---

#### 3. 🚀 Deployment via Baseten
To deploy your quantized or fine-tuned model weights to [Baseten](https://docs.baseten.co/development/model/build-your-first-model) using `Truss`:
* Set your Baseten API key: `export BASETEN_API_KEY="your_baseten_api_key"`
* Point your `config.yaml` to your Hugging Face model repository to generate an OpenAI-compatible endpoint.

---

#### 4. 🔍 Tracing & Evaluation via LangChain & LangSmith
To log traces, evaluate output quality, and monitor agent performance with [LangSmith](https://www.langchain.com/langsmith/observability):

```bash
export LANGSMITH_TRACING="true"
export LANGSMITH_ENDPOINT="[https://api.smith.langchain.com](https://api.smith.langchain.com)"
export LANGSMITH_API_KEY="your_langsmith_api_key"
export LANGSMITH_PROJECT="MyModelDeployment"
