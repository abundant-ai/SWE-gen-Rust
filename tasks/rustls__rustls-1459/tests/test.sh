#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/client_cert_verifier.rs" "rustls/tests/client_cert_verifier.rs"

# Run tests for the specific test files from this PR
# handshake_test.rs contains module tests within rustls/src/msgs
# client_cert_verifier.rs is an integration test in rustls/tests
cargo test --package rustls --lib msgs::handshake_test -- --nocapture
lib_test_status=$?

cargo test --package rustls --test client_cert_verifier -- --nocapture
integration_test_status=$?

# Exit with failure if either test failed
if [ $lib_test_status -ne 0 ] || [ $integration_test_status -ne 0 ]; then
  test_status=1
else
  test_status=0
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
