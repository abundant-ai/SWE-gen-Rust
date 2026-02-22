#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/compile-fail"
cp "/tests/compile-fail/scope_join_bad.rs" "tests/compile-fail/scope_join_bad.rs"
mkdir -p "tests/run-pass"
cp "/tests/run-pass/scope_join.rs" "tests/run-pass/scope_join.rs"

# Clean and rebuild the library to ensure we pick up any changes from Oracle agent
cargo clean 2>&1 >/dev/null
cargo build --lib 2>&1 || exit 1

# Test both run-pass and compile-fail tests
test_status=0

# Run the run-pass test (should compile and run successfully)
echo "Running run-pass test: tests/run-pass/scope_join.rs"
rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  -L target/debug/deps \
  "tests/run-pass/scope_join.rs" \
  -o "/tmp/scope_join" 2>&1

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to compile tests/run-pass/scope_join.rs"
  test_status=1
else
  "/tmp/scope_join" 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR: tests/run-pass/scope_join.rs failed at runtime"
    test_status=1
  else
    echo "PASS: tests/run-pass/scope_join.rs"
  fi
fi

# Run the compile-fail test (should fail to compile)
if [ $test_status -eq 0 ]; then
  echo "Running compile-fail test: tests/compile-fail/scope_join_bad.rs"
  rustc --edition 2018 \
    --extern rayon=target/debug/librayon.rlib \
    -L target/debug/deps \
    "tests/compile-fail/scope_join_bad.rs" \
    -o "/tmp/scope_join_bad" 2>&1 >/dev/null

  # For compile-fail tests, we expect compilation to fail
  if [ $? -eq 0 ]; then
    echo "ERROR: tests/compile-fail/scope_join_bad.rs should have failed to compile but didn't"
    test_status=1
  else
    echo "PASS: tests/compile-fail/scope_join_bad.rs (failed to compile as expected)"
  fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
