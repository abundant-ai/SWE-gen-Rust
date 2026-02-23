#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/TypedArray.rs" "crates/js-sys/tests/wasm/TypedArray.rs"

# Run js-sys tests for TypedArray
cargo test -p js-sys --target wasm32-unknown-unknown --test wasm TypedArray -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
