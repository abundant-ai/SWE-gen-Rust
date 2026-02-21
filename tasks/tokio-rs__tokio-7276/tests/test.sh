#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_metrics.rs" "tokio/tests/rt_metrics.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_unstable_metrics.rs" "tokio/tests/rt_unstable_metrics.rs"

# Run the specific test files for this PR
cd tokio
cargo test --test rt_metrics --features full
test_status1=$?
cargo test --test rt_unstable_metrics --features full
test_status2=$?

# Both tests must pass
if [ $test_status1 -eq 0 ] && [ $test_status2 -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
