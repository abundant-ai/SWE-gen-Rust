#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/replace.rs" "tests/replace.rs"

# Run the default test which includes the replace module
cargo test --test default -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
