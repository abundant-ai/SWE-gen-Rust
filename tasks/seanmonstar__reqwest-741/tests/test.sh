#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/cookie.rs" "tests/cookie.rs"
mkdir -p "tests"
cp "/tests/redirect.rs" "tests/redirect.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run the cookie and redirect tests
cargo test --test cookie --test redirect --features "blocking,native-tls,cookies" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
