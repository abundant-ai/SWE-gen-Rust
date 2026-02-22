#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/consistent.rs" "tests/consistent.rs"
mkdir -p "tests"
cp "/tests/crates_regex.rs" "tests/crates_regex.rs"
mkdir -p "tests"
cp "/tests/test_crates_regex.rs" "tests/test_crates_regex.rs"

# Run the crates-regex test which includes the modified test files
cargo test --test crates-regex -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
