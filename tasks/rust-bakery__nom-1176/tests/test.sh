#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/json.rs" "tests/json.rs"

# This PR updates both tests and benchmarks from old macro-based to modern function-based API.
# The test is: do the benchmarks compile? (They don't in BASE state due to deprecated macros)
# First check if benchmarks compile
echo "Checking if benchmarks compile..."
if cargo build --benches --features alloc 2>&1 | tee /tmp/bench_build.log | grep -q "error: could not compile"; then
  echo "Benchmarks failed to compile (expected in BASE state)"
  test_status=1
else
  echo "Benchmarks compiled successfully"
  # Also run the tests to make sure everything works
  cargo test --test json --features alloc -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
