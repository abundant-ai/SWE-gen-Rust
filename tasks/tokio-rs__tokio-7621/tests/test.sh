#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="--cfg tokio_unstable -Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/fs_try_exists.rs" "tokio/tests/fs_try_exists.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/fs_uring.rs" "tokio/tests/fs_uring.rs"

# Run the specific test files for this PR
cd tokio
cargo test --test fs_try_exists --test fs_uring --features full,io-uring
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
