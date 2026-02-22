#!/bin/bash

cd /app/src

# Copy HEAD test file
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"

# Run test with rustls-tls-webpki-roots-no-provider feature
cargo test --test badssl --features "rustls-tls,rustls-tls-webpki-roots-no-provider" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
