#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/main.rs" "tests/wasm/main.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/slice_jsvalue.js" "tests/wasm/slice_jsvalue.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/slice_jsvalue.rs" "tests/wasm/slice_jsvalue.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/variadic.rs" "tests/wasm/variadic.rs"

# Run the wasm tests for slice_jsvalue and variadic functionality
# These tests verify that &[JsValue] slices can be passed to JavaScript functions
# The tests are in tests/wasm/main.rs which includes slice_jsvalue and variadic modules
# Run slice_jsvalue tests
cargo test --target wasm32-unknown-unknown --test wasm -- --nocapture slice_jsvalue
test_status_1=$?

# Run variadic tests
cargo test --target wasm32-unknown-unknown --test wasm -- --nocapture variadic
test_status_2=$?

# Both test runs must succeed
if [ $test_status_1 -eq 0 ] && [ $test_status_2 -eq 0 ]; then
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
