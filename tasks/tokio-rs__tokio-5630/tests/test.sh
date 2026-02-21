#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/time_delay_queue.rs" "tokio-util/tests/time_delay_queue.rs"

# Run the specific time_delay_queue integration test
cd tokio-util
timeout 300 cargo test --test time_delay_queue --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
