#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/upgrade.rs" "tests/upgrade.rs"

# Fetch dependencies in case Cargo.toml was updated by fix.patch
cargo fetch 2>/dev/null || true

# Run upgrade test with required features
cargo test --test upgrade --features blocking,json -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
