#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run tests from server_cert_verifier integration test
cargo test --test server_cert_verifier -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
