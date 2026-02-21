#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_metrics.rs" "tokio/tests/rt_metrics.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_unstable_metrics.rs" "tokio/tests/rt_unstable_metrics.rs"

# Run the rt_metrics and rt_unstable_metrics tests
cargo test --test rt_metrics -- --nocapture && cargo test --test rt_unstable_metrics -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
