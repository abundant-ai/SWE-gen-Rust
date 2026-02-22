#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/compile-fail-unstable"
cp "/tests/compile-fail-unstable/future_escape.rs" "tests/compile-fail-unstable/future_escape.rs"

# Fetch dependencies (Oracle may have added futures dependency)
cargo fetch 2>&1 >/dev/null || true

# Clean and rebuild the library with unstable feature to ensure we pick up any changes from Oracle agent
cargo clean 2>&1 >/dev/null
cargo_build_output=$(cargo build --lib --features unstable 2>&1)
cargo_build_status=$?

# Check if futures dependency is available (indicates Oracle fixed the code)
if echo "$cargo_build_output" | grep -q "futures"; then
  # Futures is being compiled, Oracle has restored it
  if [ $cargo_build_status -ne 0 ]; then
    echo "ERROR: Failed to build with unstable features"
    echo "$cargo_build_output"
    echo 0 > /logs/verifier/reward.txt
    exit 1
  fi
else
  # No futures dependency, we're in BASE state (NOP agent didn't fix it)
  # The test cannot run without futures support
  echo "No futures support detected - test cannot run in BASE state"
  echo 0 > /logs/verifier/reward.txt
  exit 1
fi

# Test the compile-fail-unstable test
test_status=0

# Run the compile-fail-unstable test (should fail to compile with expected borrow checker errors)
echo "Running compile-fail-unstable test: tests/compile-fail-unstable/future_escape.rs"
compile_output=$(rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  -L target/debug/deps \
  --cfg feature=\"unstable\" \
  "tests/compile-fail-unstable/future_escape.rs" \
  -o "/tmp/future_escape" 2>&1)
compile_status=$?

# For compile-fail tests, we expect compilation to fail with specific borrow checker errors
if [ $compile_status -eq 0 ]; then
  echo "ERROR: tests/compile-fail-unstable/future_escape.rs should have failed to compile but didn't"
  test_status=1
else
  # Check that it failed with the expected errors (E0501, E0382, or borrow checker errors)
  # Not E0463 (missing crate) or E0599 (missing method) which would indicate futures not restored
  if echo "$compile_output" | grep -qE "E0463|E0599"; then
    echo "ERROR: Compilation failed with wrong errors (futures not properly restored)"
    echo "$compile_output"
    test_status=1
  else
    echo "PASS: tests/compile-fail-unstable/future_escape.rs (failed to compile with expected errors)"
  fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
