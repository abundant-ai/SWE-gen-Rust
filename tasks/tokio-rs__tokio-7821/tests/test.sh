#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/sync_broadcast.rs" "tokio/tests/sync_broadcast.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/sync_mpsc.rs" "tokio/tests/sync_mpsc.rs"

# Run the specific tests for both sync_broadcast and sync_mpsc with required features
cd tokio
cargo test --test sync_broadcast --features full && cargo test --test sync_mpsc --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
