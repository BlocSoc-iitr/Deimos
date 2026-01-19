#!/bin/bash
set -e
FILE="flutter/mopro_flutter_plugin/ios/Classes/MoproCircom.swift"

echo "Updating MoproCircom.swift..."

# Common C Types (must match header)
sed -i '' 's/RustBuffer/CircomRustBuffer/g' "$FILE"
sed -i '' 's/ForeignBytes/CircomForeignBytes/g' "$FILE"
sed -i '' 's/RustCallStatus/CircomRustCallStatus/g' "$FILE"

# Function prefixes (already namespaced by package name, but keeping safety check or mapping if needed)
# The generated code will have uniffi_deimos_circom_...
# We might want to rename ffi_deimos_circom?
# Imports
# Force the correct module import
sed -i '' 's/import deimos_circom[[:>:]]/import deimos_circomFFI/g' "$FILE"
# (No-op, just ensuring we don't break things if we change logic later)

# Types
sed -i '' 's/MoproError/CircomMoproError/g' "$FILE"
sed -i '' 's/ProofLib/CircomProofLib/g' "$FILE"

# Structs
# G1/G2 are common, so rename them.
sed -i '' 's/\bG1\b/CircomG1/g' "$FILE"
sed -i '' 's/\bG2\b/CircomG2/g' "$FILE"

# CircomProof/Result are already specific, but to be 100% safe against "CircomProof" in Noir (unlikely), we leave them or just rename if needed.
# For now, LEAVE CircomProof/CircomProofResult as is to avoid CircomCircom...
# sed -i '' 's/\bCircomProofResult\b/CircomCircomProofResult/g' "$FILE"
# sed -i '' 's/\bCircomProof\b/CircomCircomProof/g' "$FILE"

# Function Names (to avoid conflicts)
sed -i '' 's/func generateHalo2Proof/func generateHalo2Proof_Circom/g' "$FILE"
sed -i '' 's/func verifyHalo2Proof/func verifyHalo2Proof_Circom/g' "$FILE"
sed -i '' 's/func moproUniffiHelloWorld/func moproUniffiHelloWorld_Circom/g' "$FILE"
# Note: Keeping generateCircomProof as is, because it is the primary function for this module.

# Init function
# Init function
sed -i '' 's/uniffiEnsureDeimosCircomInitialized/uniffiEnsureCircomInitialized/g' "$FILE"

echo "Done."
