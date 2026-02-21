#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/async_send_sync.rs" "tokio/tests/async_send_sync.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/sync_mpsc.rs" "tokio/tests/sync_mpsc.rs"

# Run the async_send_sync and sync_mpsc tests with timeout
timeout 300 cargo test --test async_send_sync --test sync_mpsc -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
