#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/custom-section.bg.js" "crates/cli/tests/reference/custom-section.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/custom-section.d.ts" "crates/cli/tests/reference/custom-section.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/custom-section.rs" "crates/cli/tests/reference/custom-section.rs"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/custom-section.wat" "crates/cli/tests/reference/custom-section.wat"

# Run test for custom-section reference test
# The reference tests use rstest to iterate over *.rs files in tests/reference
# We filter to run only the custom_section test case (rstest generates test with hyphens converted to underscores)
test_output=$(cargo test -p wasm-bindgen-cli --test wasm-bindgen custom_section -- --nocapture 2>&1)
test_status=$?
echo "$test_output"

# Check if any tests actually ran (if 0 tests ran, it means the test file wasn't discovered at compile time)
if echo "$test_output" | grep -q "running 0 tests"; then
    echo "ERROR: No tests were run. The test file may not exist or wasn't discovered at compile time."
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
