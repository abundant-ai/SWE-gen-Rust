#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/lockfile_path.rs" "tests/testsuite/lockfile_path.rs"

# Run the specific test module for this PR
# The test file is lockfile_path.rs, run the lockfile_path test module
cargo test -p cargo --test testsuite lockfile_path -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
