#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"

# Run tests for the specific integration test file from the PR
cargo test --test api -- --nocapture
api_status=$?

# Note: handshake_test.rs is a unit test file (in src/), it runs with cargo test --lib
cargo test --lib handshake_test -- --nocapture
lib_test_status=$?

# All tests must pass
if [ $api_status -eq 0 ] && [ $lib_test_status -eq 0 ]; then
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
