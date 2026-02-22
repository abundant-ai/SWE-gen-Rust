#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/message_test.rs" "rustls/src/msgs/message_test.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"

# Run tests for the specific integration test file and unit tests in msgs module
# Integration test: rustls/tests/api.rs
# Unit tests are in rustls/src/msgs/handshake_test.rs and rustls/src/msgs/message_test.rs
cargo test --test api --locked -- --nocapture && \
cargo test --lib msgs::handshake_test --locked -- --nocapture && \
cargo test --lib msgs::message_test --locked -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
