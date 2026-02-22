#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/main.rs" "tests/wasm/main.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/try_from_js_value.js" "tests/wasm/try_from_js_value.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/try_from_js_value.rs" "tests/wasm/try_from_js_value.rs"

# Run the wasm integration test, filtering for try_from_js_value tests
cargo test --target wasm32-unknown-unknown --test wasm -- try_from_js_value
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
