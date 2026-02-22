#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/compile-fail"
cp "/tests/compile-fail/no_send_par_iter.rs" "tests/compile-fail/no_send_par_iter.rs"

# Clean and rebuild the library to ensure we pick up any changes from Oracle agent
cargo clean 2>&1 >/dev/null
cargo build --lib 2>&1 || exit 1

# Compile the test file - it should fail to compile
# We check the error messages to distinguish BASE (buggy) vs HEAD (fixed) behavior
rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  -L target/debug/deps \
  tests/compile-fail/no_send_par_iter.rs \
  -o /tmp/no_send_par_iter_test 2>&1 | tee /tmp/compile_output.txt

compile_status=${PIPESTATUS[0]}

# Compilation must fail for this test
if [ $compile_status -eq 0 ]; then
  # Compilation succeeded unexpectedly - test fails
  echo "ERROR: Test file compiled successfully, but should have failed!"
  test_status=1
else
  # Check error messages - the key difference between BASE and HEAD is the use of MapFn wrapper
  # BASE (buggy): Uses MapFn wrapper, error shows "pub struct MapFn<F>" in context
  # HEAD (fixed): No MapFn struct, uses plain function closures
  if grep -A20 "no_send_par_iter.rs:18" /tmp/compile_output.txt | grep -q "MapFn"; then
    # BASE behavior detected (MapFn wrapper in error) - test fails
    echo "FAIL: Detected BASE behavior (MapFn in error message)"
    test_status=1
  else
    # HEAD behavior (no MapFn wrapper) - test passes
    echo "PASS: Detected HEAD behavior (no MapFn in error message)"
    test_status=0
  fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
