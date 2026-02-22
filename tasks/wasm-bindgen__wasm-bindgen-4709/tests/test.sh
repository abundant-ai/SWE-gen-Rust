#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
cp "/tests/crates/cli/tests/reference/closures.bg.js" "crates/cli/tests/reference/closures.bg.js"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.rs" "tests/wasm/closures.rs"

# Run CLI reference tests for the modified reference files
# These tests compile Rust source files and compare generated JS/WAT output against reference files
# The reference tests verify that generated JS/WAT matches the expected output
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture test_05_async_number_rs test_06_async_void_rs test_09_closures_rs test_14_function_attrs_rs
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
