#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state with hickory-dns)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run client tests with hickory-dns feature (HEAD state)
cargo test --test client --features hickory-dns -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
