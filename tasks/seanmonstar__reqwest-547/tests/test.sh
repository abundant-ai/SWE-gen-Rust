#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/proxy.rs" "tests/proxy.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run client tests first
cargo test --test client -- --nocapture
client_status=$?

# Run proxy tests
cargo test --test proxy -- --nocapture
proxy_status=$?

# Overall test status (pass only if both pass)
if [ $client_status -eq 0 ] && [ $proxy_status -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
