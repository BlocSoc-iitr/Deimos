#!/bin/bash
set -e
FILE="flutter/mopro_flutter_plugin/ios/Classes/MoproNoir.swift"

echo "Updating MoproNoir.swift..."

# Common C Types (must match header)
sed -i '' 's/RustBuffer/NoirRustBuffer/g' "$FILE"
sed -i '' 's/ForeignBytes/NoirForeignBytes/g' "$FILE"
sed -i '' 's/RustCallStatus/NoirRustCallStatus/g' "$FILE"

# Imports
# Force the correct module import
sed -i '' 's/import deimos_noir[[:>:]]/import deimos_noirFFI/g' "$FILE"

# Types
sed -i '' 's/MoproError/NoirMoproError/g' "$FILE"
sed -i '' 's/ProofLib/NoirProofLib/g' "$FILE"

# Structs
# Rename G1/G2 if they exist
sed -i '' 's/\bG1\b/NoirG1/g' "$FILE"
sed -i '' 's/\bG2\b/NoirG2/g' "$FILE"

# Function Names (if any conflicts remain, but expecting separate functions)
# If generateCircomProof exists (unlikely), rename it.
sed -i '' 's/func generateCircomProof/func generateCircomProof_Noir/g' "$FILE"
sed -i '' 's/func verifyCircomProof/func verifyCircomProof_Noir/g' "$FILE"

# Init function
sed -i '' 's/uniffiEnsureDeimosNoirInitialized/uniffiEnsureNoirInitialized/g' "$FILE"

echo "Done."
