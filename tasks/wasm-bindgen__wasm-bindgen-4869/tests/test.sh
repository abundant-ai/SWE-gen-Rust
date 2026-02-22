#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-nodejs.js" "crates/cli/tests/reference/import-target-nodejs.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-nodejs.wat" "crates/cli/tests/reference/import-target-nodejs.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.js" "crates/cli/tests/reference/targets-target-nodejs-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.wat" "crates/cli/tests/reference/targets-target-nodejs-atomics.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-mvp.js" "crates/cli/tests/reference/targets-target-nodejs-mvp.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-mvp.wat" "crates/cli/tests/reference/targets-target-nodejs-mvp.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs.js" "crates/cli/tests/reference/targets-target-nodejs.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs.wat" "crates/cli/tests/reference/targets-target-nodejs.wat"

# Run the CLI reference tests for import.rs and targets.rs
# These tests generate .js and .wat files and compare them to expected output
# The test files are generated from import.rs and targets.rs with various FLAGS
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture runtest::import
test_status_1=$?

cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture runtest::targets
test_status_2=$?

cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture runtest_targets_atomics
test_status_3=$?

cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture runtest_targets_mvp
test_status_4=$?

# All test runs must succeed
if [ $test_status_1 -eq 0 ] && [ $test_status_2 -eq 0 ] && [ $test_status_3 -eq 0 ] && [ $test_status_4 -eq 0 ]; then
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
