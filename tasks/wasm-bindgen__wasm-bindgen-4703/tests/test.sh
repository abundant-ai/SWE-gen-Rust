#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-bundler-atomics.bg.js" "crates/cli/tests/reference/targets-target-bundler-atomics.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-deno-atomics.js" "crates/cli/tests/reference/targets-target-deno-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.bg.js" "crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-atomics.js" "crates/cli/tests/reference/targets-target-module-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-atomics.js" "crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-no-modules-atomics.js" "crates/cli/tests/reference/targets-target-no-modules-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.js" "crates/cli/tests/reference/targets-target-nodejs-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web-atomics.js" "crates/cli/tests/reference/targets-target-web-atomics.js"

# Run CLI reference tests for targets with atomics
# These tests compile targets.rs with atomics flags and compare generated JS/WAT output against reference files
# The test generates output files like targets-target-{bundler,deno,web,etc}-atomics.{js,bg.js,wat,d.ts}
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture reference::runtest_targets_atomics
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
