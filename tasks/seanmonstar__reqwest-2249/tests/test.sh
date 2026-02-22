#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"

# Run badssl tests with rustls-tls feature
# In BASE: test_badssl_wrong_host only works with native-tls, filtered out with rustls-tls
# In HEAD: test_badssl_wrong_host works with both native-tls and rustls-tls
cargo test --test badssl --features rustls-tls -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
