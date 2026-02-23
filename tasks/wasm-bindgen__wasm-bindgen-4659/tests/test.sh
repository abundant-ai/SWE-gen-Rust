#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/WeakRef.rs" "crates/js-sys/tests/wasm/WeakRef.rs"
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/main.rs" "crates/js-sys/tests/wasm/main.rs"

# Run tests in the js-sys crate for the wasm tests
cargo test --target wasm32-unknown-unknown -p js-sys --test wasm -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
