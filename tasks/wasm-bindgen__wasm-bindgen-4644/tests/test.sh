#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-6.d.ts" "crates/cli/tests/reference/targets-6.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-6.js" "crates/cli/tests/reference/targets-6.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-6.wat" "crates/cli/tests/reference/targets-6.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets.rs" "crates/cli/tests/reference/targets.rs"

# Run the specific targets test
cargo test -p wasm-bindgen-cli --test reference runtest::test_29_targets_rs -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
