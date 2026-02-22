#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/compile-fail"
cp "/tests/compile-fail/must_use.rs" "tests/compile-fail/must_use.rs"

# Build the library first
cargo build --lib 2>&1 || exit 1

# This is a compile-fail test - it should fail compilation with #![deny(unused_must_use)]
# when certain adaptors are not marked with #[must_use]
# In BASE state: zip_eq is missing, so the test file won't compile (missing method)
# In HEAD state: zip_eq exists and is marked #[must_use], so compilation fails with proper errors

# Try to compile the test file and capture output
compile_output=$(rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  -L target/debug/deps \
  tests/compile-fail/must_use.rs \
  -o /tmp/test_binary 2>&1)

compile_status=$?

# For a compile-fail test:
# In BASE state: compilation fails because zip_eq method doesn't exist (FAIL - wrong error)
# In HEAD state: compilation fails because of #[must_use] warnings becoming errors (PASS - expected)
# Check if we get the expected must_use errors, not method-not-found errors

if [ $compile_status -ne 0 ]; then
  # Compilation failed - check if it's because of missing method (BASE) or must_use errors (HEAD)
  if echo "$compile_output" | grep -q "no method named"; then
    # BASE state: zip_eq method doesn't exist - this is a failure
    test_status=1
  elif echo "$compile_output" | grep -q "unused"; then
    # HEAD state: must_use warnings/errors - this is success (expected failure)
    test_status=0
  else
    # Some other compilation error
    echo "$compile_output"
    test_status=1
  fi
else
  # Compilation succeeded - this is wrong, the test should fail with must_use errors
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
