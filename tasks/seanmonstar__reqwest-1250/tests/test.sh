#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
cp "/tests/deflate.rs" "tests/deflate.rs"

# Check if deflate feature exists in Cargo.toml
if ! grep -q 'deflate = \["async-compression"' Cargo.toml; then
    # deflate feature doesn't exist - this means the fix wasn't applied
    echo "ERROR: deflate feature not found in Cargo.toml - fix not applied" >&2
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run both test files with required features
cargo test --test client --test deflate --features blocking,json,deflate -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
