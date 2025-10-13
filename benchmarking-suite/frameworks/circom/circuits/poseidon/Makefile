# Circuit Build and Verification Makefile
# Parameters: CIRCUIT (circuit name) and POT (powers of tau)
# Usage: make full CIRCUIT=multiplier2 POT=12

# Configuration - can be overridden
HASH_NAME ?= poseidon
CIRCUIT ?= poseidon_circom
POT ?= 16
INPUT_FILE ?= input_8.json

# Derived file names
INPUT_JSON = ../../inputs/$(HASH_NAME)/$(INPUT_FILE)
PTAU_0000 = pot$(POT)_0000.ptau
PTAU_0001 = pot$(POT)_0001.ptau
PTAU_FINAL = pot$(POT)_final.ptau
R1CS_FILE = $(CIRCUIT).r1cs
WASM_FILE = $(CIRCUIT).wasm
WITNESS_FILE = witness.wtns
ZKEY_0000 = $(CIRCUIT)_0000.zkey
ZKEY_0001 = $(CIRCUIT)_0001.zkey
VERIFICATION_KEY = verification_key.json
PROOF_FILE = proof.json
PUBLIC_FILE = public.json

# Main target - complete workflow
.PHONY: full
full:
	@echo "🔧 Step 1: Compiling circuit $(CIRCUIT).circom..."
	circom $(CIRCUIT).circom --r1cs --wasm --sym --c
	
	@echo "🧮 Step 2: Generating witness..."
	cd $(CIRCUIT)_js && node generate_witness.js $(WASM_FILE) ../$(INPUT_JSON) $(WITNESS_FILE)
	
	@echo "🌟 Step 3: Creating new powers of tau..."
	snarkjs powersoftau new bn128 $(POT) $(PTAU_0000) -v
	
	@echo "🤝 Step 4: Contributing to powers of tau..."
	echo "random entropy" | snarkjs powersoftau contribute $(PTAU_0000) $(PTAU_0001) --name="First contribution" -v
	
	@echo "🔄 Step 5: Preparing phase 2..."
	snarkjs powersoftau prepare phase2 $(PTAU_0001) $(PTAU_FINAL) -v
	
	@echo "🔑 Step 6: Groth16 setup..."
	snarkjs groth16 setup $(R1CS_FILE) $(PTAU_FINAL) $(ZKEY_0000)
	
	@echo "🤝 Step 7: Contributing to zkey..."
	echo "random entropy" | snarkjs zkey contribute $(ZKEY_0000) $(ZKEY_0001) --name="1st Contributor Name" -v
	
	@echo "📤 Step 8: Exporting verification key..."
	snarkjs zkey export verificationkey $(ZKEY_0001) $(VERIFICATION_KEY)
	
	@echo "🔐 Step 9: Generating proof..."
	snarkjs groth16 prove $(ZKEY_0001) $(CIRCUIT)_js/$(WITNESS_FILE) $(PROOF_FILE) $(PUBLIC_FILE)
	
	@echo "🔍 Step 10: Verifying proof..."
	snarkjs groth16 verify $(VERIFICATION_KEY) $(PUBLIC_FILE) $(PROOF_FILE)
	
	@echo "✅ Complete workflow finished successfully!"

# Clean all generated files
.PHONY: clean
clean:
	@echo "🧹 Cleaning generated files..."
	rm -rf $(CIRCUIT)_js/ $(CIRCUIT)_cpp/
	rm -f $(R1CS_FILE) $(ZKEY_0000) $(ZKEY_0001) $(VERIFICATION_KEY)
	rm -f $(PROOF_FILE) $(PUBLIC_FILE) $(CIRCUIT).sym
	rm -f $(PTAU_0000) $(PTAU_0001) $(PTAU_FINAL)
	@echo "✅ Clean complete"

# Help target
.PHONY: help
help:
	@echo "Circuit Build and Verification Makefile"
	@echo "======================================"
	@echo ""
	@echo "Usage:"
	@echo "  make full CIRCUIT=<name> POT=<power> INPUT_FILE=<input>"
	@echo ""
	@echo "Examples:"
	@echo "  make full CIRCUIT=multiplier2 POT=12"
	@echo "  make full CIRCUIT=circom POT=16 INPUT_FILE=input.json"
	@echo ""
	@echo "Parameters:"
	@echo "  CIRCUIT      - Circuit name (default: circom)"
	@echo "  POT          - Powers of tau (default: 16)"
	@echo "  INPUT_FILE   - Input JSON file (default: input.json)"
	@echo ""
	@echo "Targets:"
	@echo "  full         - Complete workflow (compile → prove → verify)"
	@echo "  clean        - Remove all generated files"
	@echo "  help         - Show this help message"
