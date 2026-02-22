#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/timeouts.rs" "tests/timeouts.rs"
mkdir -p "tests"
cp "/tests/wasm_simple.rs" "tests/wasm_simple.rs"

# Fetch dependencies in case Cargo.toml was updated by fix.patch
cargo fetch 2>/dev/null || true

# Run timeouts test (non-wasm)
cargo test --test timeouts --features blocking,json -- --nocapture
timeouts_status=$?

# For wasm, verify that the code and test compile for wasm32 target
# This will fail in BASE state if the timeout API is missing from src/wasm/*
cargo build --target wasm32-unknown-unknown --test wasm_simple --features json
wasm_build_status=$?

# Both must succeed
if [ $timeouts_status -eq 0 ] && [ $wasm_build_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
