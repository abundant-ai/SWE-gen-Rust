#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "connect-tests/tests"
cp "/tests/connect-tests/tests/ech.rs" "connect-tests/tests/ech.rs"

# Run tests for the specific integration test file from the PR
# The ech.rs file is in the rustls-connect-tests package, not the main rustls crate
cargo test -p rustls-connect-tests --test ech -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
