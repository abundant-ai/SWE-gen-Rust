#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
cp "/tests/rustls/tests/unbuffered.rs" "rustls/tests/unbuffered.rs"

# Run the specific integration test files for this PR
cargo test --test api --locked -- --nocapture
test_status_api=$?

cargo test --test unbuffered --locked -- --nocapture
test_status_unbuffered=$?

# Both tests must pass
if [ $test_status_api -eq 0 ] && [ $test_status_unbuffered -eq 0 ]; then
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
