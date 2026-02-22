#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/deflate.rs" "tests/deflate.rs"

# Fetch dependencies in case Cargo.toml was updated by fix.patch
cargo fetch 2>/dev/null || true

# Run deflate test with required features
cargo test --test deflate --features blocking,json,deflate -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
