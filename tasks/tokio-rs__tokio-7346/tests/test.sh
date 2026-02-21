#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="--cfg tokio_unstable -Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/async_send_sync.rs" "tokio/tests/async_send_sync.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_local.rs" "tokio/tests/rt_local.rs"

# Run the specific test files for this PR
cd tokio
cargo test --test async_send_sync --test rt_local --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
