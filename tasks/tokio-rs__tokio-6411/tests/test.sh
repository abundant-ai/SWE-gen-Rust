#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/fs/file"
cp "/tests/tokio/src/fs/file/tests.rs" "tokio/src/fs/file/tests.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/fs_file.rs" "tokio/tests/fs_file.rs"

# Run the specific integration test and doc tests
cd tokio
timeout 300 cargo test --test fs_file --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
