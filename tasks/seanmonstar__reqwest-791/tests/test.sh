#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/brotli.rs" "tests/brotli.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/gzip.rs" "tests/gzip.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run each test with its required features
cargo test --test brotli --features blocking,brotli -- --nocapture && \
cargo test --test client --features blocking,json -- --nocapture && \
cargo test --test gzip --features blocking,gzip -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
