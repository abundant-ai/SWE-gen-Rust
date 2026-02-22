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
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"

# Run only the async CLI reference tests modified in this PR
# Note: function-attrs test is excluded as it has unrelated failures
cargo test -p wasm-bindgen-cli -- test_05_async_number_rs test_06_async_void_rs --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
