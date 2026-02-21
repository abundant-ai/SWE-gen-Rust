#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/src/msgs"
cp "/tests/rustls/src/msgs/handshake_test.rs" "rustls/src/msgs/handshake_test.rs"

# Run tests in the handshake_test module (unit tests are in the rustls lib)
cargo test --lib --all-features handshake_test -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
