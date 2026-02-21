#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/sync/tests"
cp "/tests/tokio/src/sync/tests/loom_semaphore_batch.rs" "tokio/src/sync/tests/loom_semaphore_batch.rs"
mkdir -p "tokio/src/sync/tests"
cp "/tests/tokio/src/sync/tests/semaphore_batch.rs" "tokio/src/sync/tests/semaphore_batch.rs"

# Run the specific unit tests in the semaphore_batch module
cd tokio
timeout 300 cargo test --lib semaphore_batch --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
