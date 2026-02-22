#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy ALL reference test files from /tests (overwrites BASE state)
# The PR modifies code generation logic that affects all reference outputs,
# so we need to copy all reference files, not just the ones explicitly changed
cp -r /tests/crates/cli/tests/reference/* crates/cli/tests/reference/

# Delete files that were removed by the PR
# The PR removes separate _bg.js files for experimental-nodejs-module target
rm -f crates/cli/tests/reference/import-target-experimental-nodejs-module.bg.js
rm -f crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.bg.js
rm -f crates/cli/tests/reference/targets-target-experimental-nodejs-module-mvp.bg.js
rm -f crates/cli/tests/reference/targets-target-experimental-nodejs-module.bg.js

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
