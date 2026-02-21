#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "ignore/tests"
cp "/tests/ignore/tests/gitignore_matched_path_or_any_parents_tests.rs" "ignore/tests/gitignore_matched_path_or_any_parents_tests.rs"

# Run the specific test file in the ignore crate
cd ignore
cargo test --test gitignore_matched_path_or_any_parents_tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
