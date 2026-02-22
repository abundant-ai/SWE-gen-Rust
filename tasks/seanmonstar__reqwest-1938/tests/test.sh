#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/blocking.rs" "tests/blocking.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run blocking test with blocking feature
cargo test --test blocking --features blocking -- --nocapture
test_status=$?

# Run client test (doesn't require specific features)
if [ $test_status -eq 0 ]; then
  cargo test --test client -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
