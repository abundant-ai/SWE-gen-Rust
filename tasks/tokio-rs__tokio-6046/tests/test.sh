#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/task_join_map.rs" "tokio-util/tests/task_join_map.rs"

# Run the specific integration test
cd tokio-util
timeout 300 cargo test --test task_join_map --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
