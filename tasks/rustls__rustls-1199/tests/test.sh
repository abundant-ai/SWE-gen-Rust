#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run the specific test file for this PR (requires dangerous_configuration feature)
cargo test --package rustls --test server_cert_verifier --features=dangerous_configuration 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
