#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/http3.rs" "tests/http3.rs"

# Run specific integration tests for this PR with required features
# http3 feature requires unstable flag, stream feature is needed for the tests
cargo test --test http3 --features http3,stream -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
