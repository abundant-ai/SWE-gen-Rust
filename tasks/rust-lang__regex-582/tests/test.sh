#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/error_messages.rs" "tests/error_messages.rs"
mkdir -p "tests"
cp "/tests/test_default.rs" "tests/test_default.rs"

# Run the specific test for this PR
# error_messages.rs is included in test_default.rs as a module
cargo test --test default -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
