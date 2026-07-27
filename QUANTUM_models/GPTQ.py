# @title ## 🧠 GPTQ

# @markdown Learn more about the GPTQ algorithm in [this article](https://mlabonne.github.io/blog/posts/4_bit_Quantization_with_GPTQ.html).

!pip install auto-gptq optimum accelerate

from transformers import AutoModelForCausalLM, AutoTokenizer, GPTQConfig

BITS = 4 # @param {type:"integer"}
GROUP_SIZE = 128 # @param {type:"integer"}
DAMP_PERCENT = 0.1 # @param {type:"number"}

# Quantize model
tokenizer = AutoTokenizer.from_pretrained(MODEL_ID)
quantization_config = GPTQConfig(bits=BITS, dataset="c4", tokenizer=tokenizer, damp_percent=DAMP_PERCENT)
model = AutoModelForCausalLM.from_pretrained(MODEL_ID, device_map="auto", quantization_config=quantization_config, low_cpu_mem_usage=True)

# Save model and tokenizer
save_folder = MODEL_ID + "-GPTQ"
model.save_pretrained(save_folder, use_safetensors=True)
tokenizer.save_pretrained(save_folder)

# Upload quant
upload_model(
    base_model_id=MODEL_ID,
    quantized_model_name=f"{MODEL_NAME}-GPTQ",
    quantization_type="gptq",
    save_folder=save_folder
)
