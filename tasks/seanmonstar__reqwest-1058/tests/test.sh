#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run badssl tests with rustls-tls-webpki-roots feature (tests the new feature flags)
cargo test --test badssl --features blocking,json,rustls-tls-webpki-roots -- --nocapture
badssl_status=$?

# Run client tests with rustls-tls feature
cargo test --test client --features blocking,json,rustls-tls -- --nocapture
client_status=$?

# Both tests must pass
if [ $badssl_status -eq 0 ] && [ $client_status -eq 0 ]; then
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
