#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/blocking.rs" "tests/blocking.rs"
cp "/tests/client.rs" "tests/client.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run the blocking and client tests with blocking and json features enabled
cargo test --test blocking --test client --features blocking,json -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
