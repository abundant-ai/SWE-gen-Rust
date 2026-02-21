#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/unbuffered.rs" "rustls/tests/unbuffered.rs"

# Run tests for the specific integration test files from the PR
cargo test --test api -- --nocapture
api_status=$?

cargo test --test unbuffered -- --nocapture
unbuffered_status=$?

# Both tests must pass
if [ $api_status -eq 0 ] && [ $unbuffered_status -eq 0 ]; then
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
