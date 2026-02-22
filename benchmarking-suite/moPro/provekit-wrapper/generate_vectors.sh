#!/bin/bash
set -e

PROVEKIT_CLI="/home/anand/Deimos/benchmarking-suite/moPro/provekit/target/release/provekit-cli"
NOIR_DIR="/home/anand/Deimos/benchmarking-suite/moPro/mopro-example-app/flutter/assets/noir"
OUT_DIR="/home/anand/Deimos/benchmarking-suite/moPro/provekit-wrapper/test_vectors"

mkdir -p "$OUT_DIR"

algorithms=("anemoi" "mimc" "poseidon" "rescue_prime")
field_sizes=("1" "2" "3" "5" "9" "17" "34")

for algo in "${algorithms[@]}"; do
    for size in "${field_sizes[@]}"; do
        json_file="$NOIR_DIR/${algo}_field_${size}.json"
        
        pkp_file="$OUT_DIR/${algo}_field_${size}.pkp"
        pkv_file="$OUT_DIR/${algo}_field_${size}.pkv"
        
        if [ -f "$json_file" ]; then
            echo "Generating keys for $algo field $size..."
            $PROVEKIT_CLI prepare "$json_file" --pkp "$pkp_file" --pkv "$pkv_file"
        else
            echo "Warning: Json file not found: $json_file"
        fi
    done
done

byte_sizes=("16" "32" "64" "128" "256" "512" "1028")
for size in "${byte_sizes[@]}"; do
    json_file="$NOIR_DIR/sha256_bytes_${size}.json"
    
    pkp_file="$OUT_DIR/sha256_bytes_${size}.pkp"
    pkv_file="$OUT_DIR/sha256_bytes_${size}.pkv"
    
    if [ -f "$json_file" ]; then
        echo "Generating keys for sha256 bytes $size..."
        $PROVEKIT_CLI prepare "$json_file" --pkp "$pkp_file" --pkv "$pkv_file"
    else
        echo "Warning: Json file not found: $json_file"
    fi
done

echo "Done generating all keys."
