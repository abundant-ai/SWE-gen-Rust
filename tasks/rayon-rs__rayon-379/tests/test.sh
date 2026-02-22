#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/run-pass"
cp "/tests/run-pass/sort-panic-safe.rs" "tests/run-pass/sort-panic-safe.rs"

# Build the library first
cargo build --lib 2>&1 || exit 1

# This is a run-pass test - it should successfully compile and run
# We need to compile and run the test file as a standalone binary
# Note: There are multiple rand versions; we use the 0.3.x one (dev-dependency)
rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  --extern lazy_static \
  --extern rand=target/debug/deps/librand-42f40da42575be25.rlib \
  -L target/debug/deps \
  tests/run-pass/sort-panic-safe.rs \
  -o /tmp/sort_panic_safe_test 2>&1

compile_status=$?

if [ $compile_status -eq 0 ]; then
  # Compilation succeeded - now run the test
  /tmp/sort_panic_safe_test
  test_status=$?
else
  # Compilation failed
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
