#!/bin/bash

# Exit on error
set -e

# Directories
CONFIG_DIR="src/configs"
BACKUP_DIR="src/backup_tmp"
FLUTTER_IOS_PLUGIN_DIR="flutter/mopro_flutter_plugin/ios/Classes"
IOS_BINDINGS_DIR="MoproiOSBindings"

echo "=========================================================="
echo "   Generating iOS Bindings for Circom & Noir (Auto-Swap)"
echo "=========================================================="

# 1. Backup current config
echo "[+] Backing up current configuration..."
mkdir -p "$BACKUP_DIR"
cp src/lib.rs "$BACKUP_DIR/"
cp Cargo.toml "$BACKUP_DIR/"
cp build.rs "$BACKUP_DIR/"

cleanup() {
    echo "[+] Restoring original configuration..."
    cp "$BACKUP_DIR/lib.rs" src/lib.rs
    cp "$BACKUP_DIR/Cargo.toml" Cargo.toml
    cp "$BACKUP_DIR/build.rs" build.rs
    rm -rf "$BACKUP_DIR"
    echo "[+] Done. Environment restored for standard Android build."
}

# Ensure cleanup runs on exit or interrupt
trap cleanup EXIT

# ==============================================================================
# PHASE 1: Build Circom
# ==============================================================================
echo ""
echo ">>> Building CIRCOM Bindings..."
cp "$CONFIG_DIR/lib_circom.rs" src/lib.rs
cp "$CONFIG_DIR/Cargo_circom.toml" Cargo.toml
cp "$CONFIG_DIR/build_circom.rs" build.rs

# Fix for w2c2/rust-witness compatibility issue
export CFLAGS="-DW2C2_LOOP_START="

# Clean previous build artifacts to ensure fresh witness compilation
echo "[+] Cleaning previous artifacts..."
rm -rf test-vectors/circom/witnesscalc
cargo clean

# Build (iOS only)
mopro build --platforms ios

# Copy generated binding to plugin dir as MoproCircom.swift
echo "[+] Copying generated bindings to MoproCircom.swift..."
cp "$IOS_BINDINGS_DIR/mopro.swift" "$FLUTTER_IOS_PLUGIN_DIR/MoproCircom.swift"

# Copy generated framework to plugin dir as MoproCircomBindings.xcframework
echo "[+] Copying generated framework to MoproCircomBindings.xcframework..."
rm -rf "$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproCircomBindings.xcframework"
cp -R "$IOS_BINDINGS_DIR/MoproBindings.xcframework" "$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproCircomBindings.xcframework"

# PATCH HEADER FILES (Manual fix automation)
# Rename RustBuffer -> CircomRustBuffer, etc. in the DEPLOYED headers
CIRCOM_HEADERS_DIR="$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproCircomBindings.xcframework/ios-arm64/Headers/deimos_circom"
if [ -d "$CIRCOM_HEADERS_DIR" ]; then
    echo "[+] Renaming types in deployed Circom header files..."
    find "$CIRCOM_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/RustBuffer/CircomRustBuffer/g' {} +
    find "$CIRCOM_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/ForeignBytes/CircomForeignBytes/g' {} +
    find "$CIRCOM_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/RustCallStatus/CircomRustCallStatus/g' {} +
    find "$CIRCOM_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/UNIFFI_SHARED_H/UNIFFI_SHARED_H_CIRCOM/g' {} +
    find "$CIRCOM_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/UNIFFI_SHARED_HEADER_V4/UNIFFI_SHARED_HEADER_V4_CIRCOM/g' {} +
else
    echo "WARNING: Circom headers not found at $CIRCOM_HEADERS_DIR"
fi

# Run rename script
./update_mopro_circom.sh

# ==============================================================================
# PHASE 2: Build Noir
# ==============================================================================
echo ""
echo ">>> Building NOIR Bindings..."
cp "$CONFIG_DIR/lib_noir.rs" src/lib.rs
cp "$CONFIG_DIR/Cargo_noir.toml" Cargo.toml
cp "$CONFIG_DIR/build_noir.rs" build.rs

# Build (iOS only)
mopro build --platforms ios

# Copy generated binding to plugin dir as MoproNoir.swift
echo "[+] Copying generated bindings to MoproNoir.swift..."
cp "$IOS_BINDINGS_DIR/mopro.swift" "$FLUTTER_IOS_PLUGIN_DIR/MoproNoir.swift"

# Copy generated framework to plugin dir as MoproNoirBindings.xcframework
echo "[+] Copying generated framework to MoproNoirBindings.xcframework..."
rm -rf "$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproNoirBindings.xcframework"
cp -R "$IOS_BINDINGS_DIR/MoproBindings.xcframework" "$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproNoirBindings.xcframework"

# PATCH HEADER FILES (Manual fix automation)
NOIR_HEADERS_DIR="$FLUTTER_IOS_PLUGIN_DIR/../Frameworks/MoproNoirBindings.xcframework/ios-arm64/Headers/deimos_noir"
if [ -d "$NOIR_HEADERS_DIR" ]; then
    echo "[+] Renaming types in deployed Noir header files..."
    find "$NOIR_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/RustBuffer/NoirRustBuffer/g' {} +
    find "$NOIR_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/ForeignBytes/NoirForeignBytes/g' {} +
    find "$NOIR_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/RustCallStatus/NoirRustCallStatus/g' {} +
    find "$NOIR_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/UNIFFI_SHARED_H/UNIFFI_SHARED_H_NOIR/g' {} +
    find "$NOIR_HEADERS_DIR" -name "*.h" -exec sed -i '' 's/UNIFFI_SHARED_HEADER_V4/UNIFFI_SHARED_HEADER_V4_NOIR/g' {} +
else
    echo "WARNING: Noir headers not found at $NOIR_HEADERS_DIR"
fi

# Run rename script
./update_mopro_noir.sh

echo ""
echo ">>> SUCCESS: Both bindings generated and renamed."
