#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run the specific tests - handshake_test is a module test, server_cert_verifier is an integration test
cargo test --package rustls --lib msgs::handshake_test -- --nocapture 2>&1 && \
cargo test --package rustls --test server_cert_verifier -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
