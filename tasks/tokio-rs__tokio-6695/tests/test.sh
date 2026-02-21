#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_unstable_metrics.rs" "tokio/tests/rt_unstable_metrics.rs"

# Rebuild the tokio package to pick up any changes from fix.patch
cd tokio
cargo build --features full
cd ..

# Run only the specific test file for this PR (rt_unstable_metrics)
cd tokio
timeout 300 cargo test --test rt_unstable_metrics --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
