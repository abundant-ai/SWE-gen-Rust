#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.d.ts" "crates/cli/tests/reference/function-attrs.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/private.d.ts" "crates/cli/tests/reference/private.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.d.ts" "crates/cli/tests/reference/wasm-export-colon.d.ts"

# Run the CLI reference tests for function-attrs, private, and wasm-export-colon
# These tests generate .d.ts, .js, and .wat files and compare them to expected output
# The rstest parameterized tests use the file path in the test name
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture function-attrs
test_status_1=$?

cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture private
test_status_2=$?

cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture wasm-export-colon
test_status_3=$?

# All test runs must succeed
if [ $test_status_1 -eq 0 ] && [ $test_status_2 -eq 0 ] && [ $test_status_3 -eq 0 ]; then
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
