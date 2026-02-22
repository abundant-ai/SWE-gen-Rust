#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy all reference test output files from /tests (overwrites BASE state with HEAD state)
# This includes all .bg.js, .wat, .d.ts, and .js files that were modified by the fix
cp -r /tests/crates/cli/tests/reference/* crates/cli/tests/reference/

# Run the wasm-bindgen CLI integration tests
# These tests verify the reference outputs (JS and WAT files) for the test suite
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
