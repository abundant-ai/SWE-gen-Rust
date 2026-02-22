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
cp "/tests/crates/cli/tests/reference/wasm-export-colon.js" "crates/cli/tests/reference/wasm-export-colon.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.wat" "crates/cli/tests/reference/wasm-export-colon.wat"

# Run the reference test suite which compares generated output against expected files
# This includes async-number, async-void, closures, function-attrs, and wasm-export-colon tests
cargo test -p wasm-bindgen-cli --test wasm-bindgen -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
