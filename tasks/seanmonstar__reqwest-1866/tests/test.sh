#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/zstd.rs" "tests/zstd.rs"

# Fetch dependencies in case Cargo.toml was updated by fix.patch
cargo fetch 2>/dev/null || true

# Run specific tests for client and zstd
cargo test --test client -- --nocapture
client_status=$?

cargo test --test zstd --features zstd,stream -- --nocapture
zstd_status=$?

# Both tests must pass
if [ $client_status -eq 0 ] && [ $zstd_status -eq 0 ]; then
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
