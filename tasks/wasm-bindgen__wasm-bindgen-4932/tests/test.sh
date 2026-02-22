#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.bg.js" "crates/cli/tests/reference/default-class.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/reserved-class-name.bg.js" "crates/cli/tests/reference/reserved-class-name.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/reserved-class-name.d.ts" "crates/cli/tests/reference/reserved-class-name.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/reserved-class-name.js" "crates/cli/tests/reference/reserved-class-name.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/reserved-class-name.rs" "crates/cli/tests/reference/reserved-class-name.rs"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/reserved-class-name.wat" "crates/cli/tests/reference/reserved-class-name.wat"

# Run the reference tests for reserved-class-name
# The rstest framework generates tests based on .rs files in tests/reference/
# We run only the specific test for reserved-class-name.rs to avoid unrelated test failures
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_31_reserved_class_name_rs -- --exact --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
