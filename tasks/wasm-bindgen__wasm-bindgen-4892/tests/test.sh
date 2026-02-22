#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.bg.js" "crates/cli/tests/reference/closures.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-deno.js" "crates/cli/tests/reference/import-target-deno.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-experimental-nodejs-module.js" "crates/cli/tests/reference/import-target-experimental-nodejs-module.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-module-experimental-reset-state-function.js" "crates/cli/tests/reference/import-target-module-experimental-reset-state-function.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-module.js" "crates/cli/tests/reference/import-target-module.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-nodejs.js" "crates/cli/tests/reference/import-target-nodejs.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-web.js" "crates/cli/tests/reference/import-target-web.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/js-namespace-export.bg.js" "crates/cli/tests/reference/js-namespace-export.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/private.bg.js" "crates/cli/tests/reference/private.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-deno-atomics.js" "crates/cli/tests/reference/targets-target-deno-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.js" "crates/cli/tests/reference/targets-target-experimental-nodejs-module-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-atomics.js" "crates/cli/tests/reference/targets-target-module-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-atomics.js" "crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-mvp.js" "crates/cli/tests/reference/targets-target-module-experimental-reset-state-function-mvp.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-module-experimental-reset-state-function.js" "crates/cli/tests/reference/targets-target-module-experimental-reset-state-function.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-no-modules-atomics.js" "crates/cli/tests/reference/targets-target-no-modules-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-no-modules-mvp.js" "crates/cli/tests/reference/targets-target-no-modules-mvp.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-no-modules.js" "crates/cli/tests/reference/targets-target-no-modules.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-nodejs-atomics.js" "crates/cli/tests/reference/targets-target-nodejs-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web-atomics.js" "crates/cli/tests/reference/targets-target-web-atomics.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web-mvp.js" "crates/cli/tests/reference/targets-target-web-mvp.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/targets-target-web.js" "crates/cli/tests/reference/targets-target-web.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.d.ts" "crates/cli/tests/reference/wasm-export-colon.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.js" "crates/cli/tests/reference/wasm-export-colon.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.wat" "crates/cli/tests/reference/wasm-export-colon.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-types.js" "crates/cli/tests/reference/wasm-export-types.js"

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
