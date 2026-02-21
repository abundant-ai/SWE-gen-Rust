#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api_ffdhe.rs" "rustls/tests/api_ffdhe.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run tests for the specific integration test files from the PR
cargo test --test api -- --nocapture
api_status=$?

cargo test --test api_ffdhe -- --nocapture
api_ffdhe_status=$?

cargo test --test server_cert_verifier -- --nocapture
server_cert_verifier_status=$?

# Note: handshake_test.rs is a unit test file (in src/), it runs with cargo test --lib
# But we'll run it separately to be explicit
cargo test --lib handshake_test -- --nocapture
lib_test_status=$?

# All tests must pass
if [ $api_status -eq 0 ] && [ $api_ffdhe_status -eq 0 ] && [ $server_cert_verifier_status -eq 0 ] && [ $lib_test_status -eq 0 ]; then
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
