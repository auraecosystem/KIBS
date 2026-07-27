from web3 import Web3
import solcx

# 1. Compile source locally with identical settings
compiled_sol = solcx.compile_standard({
    "language": "Solidity",
    "sources": {"Contract.sol": {"content": source_code}},
    "settings": {"optimizer": {"enabled": True, "runs": 200}, "outputSelection": {"*": {"*": ["evm.bytecode.object"]}}}
}, solc_version="0.8.20")

local_bytecode = compiled_sol['contracts']['Contract.sol']['MyContract']['evm']['bytecode']['object']

# 2. Fetch deployed bytecode
w3 = Web3(Web3.HTTPProvider("https://fadakachain.network")) # Example RPC
deployed_bytecode = w3.eth.get_code(contract_address).hex()

# 3. Match (Strip metadata for partial matching if necessary)
is_verified = local_bytecode in deployed_bytecode
