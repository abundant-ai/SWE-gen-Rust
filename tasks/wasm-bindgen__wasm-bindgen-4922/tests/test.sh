#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.d.ts" "crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.js" "crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-no-modules-atomics.js" "crates/cli/tests/reference/targets-target-no-modules-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.d.ts" "crates/cli/tests/reference/targets-target-nodejs-atomics.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.js" "crates/cli/tests/reference/targets-target-nodejs-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-experimental-reset-state-function-atomics.d.ts" "crates/cli/tests/reference/targets-target-nodejs-experimental-reset-state-function-atomics.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-experimental-reset-state-function-atomics.js" "crates/cli/tests/reference/targets-target-nodejs-experimental-reset-state-function-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web-atomics.js" "crates/cli/tests/reference/targets-target-web-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web-experimental-reset-state-function-atomics.js" "crates/cli/tests/reference/targets-target-web-experimental-reset-state-function-atomics.js"

# Run the targets atomics reference test
# This test validates the generated output for Node.js targets with atomics enabled
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest_targets_atomics -- --exact --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
