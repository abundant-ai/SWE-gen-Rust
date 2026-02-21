#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"
export MIRIFLAGS="-Zmiri-disable-isolation"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_metrics.rs" "tokio/tests/rt_metrics.rs"

# Run the rt_metrics integration test
cd tokio
cargo test --test rt_metrics --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
