#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "ignore/tests"
cp "/tests/ignore/tests/gitignore_matched_path_or_any_parents_tests.gitignore" "ignore/tests/gitignore_matched_path_or_any_parents_tests.gitignore"
mkdir -p "ignore/tests"
cp "/tests/ignore/tests/gitignore_matched_path_or_any_parents_tests.rs" "ignore/tests/gitignore_matched_path_or_any_parents_tests.rs"

# Rebuild the project to pick up any source code changes from fix.patch
cargo build --tests

# Run only the specific test(s) for this PR
# The test file is ignore/tests/gitignore_matched_path_or_any_parents_tests.rs
# In Rust, integration tests in tests/ directory are run with --test <filename_without_extension>
cd ignore
cargo test --test gitignore_matched_path_or_any_parents_tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
