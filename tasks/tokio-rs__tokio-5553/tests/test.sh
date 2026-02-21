#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/time/tests"
cp "/tests/tokio/src/runtime/time/tests/mod.rs" "tokio/src/runtime/time/tests/mod.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/time_interval.rs" "tokio/tests/time_interval.rs"

# Run the specific integration test for time_interval
cd tokio
timeout 300 cargo test --test time_interval --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
