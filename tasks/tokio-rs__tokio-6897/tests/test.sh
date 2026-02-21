#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_unstable_metrics.rs" "tokio/tests/rt_unstable_metrics.rs"

# Run rt_unstable_metrics test with unstable cfg (tests unstable API)
cd tokio
export RUSTFLAGS="-Dwarnings --cfg tokio_unstable"
cargo test --test rt_unstable_metrics --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
