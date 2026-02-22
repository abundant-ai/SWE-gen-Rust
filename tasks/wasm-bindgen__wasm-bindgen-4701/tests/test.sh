#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/WebAssembly.rs" "crates/js-sys/tests/wasm/WebAssembly.rs"

# Run js-sys wasm tests - the HEAD test file uses get_raw/set_raw which don't exist in BASE
# This will fail during compilation in BASE state because the methods are missing
cargo test --target wasm32-unknown-unknown -p js-sys --test wasm -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
