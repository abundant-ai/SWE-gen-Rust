#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/fnmut.rs" "tests/fnmut.rs"
mkdir -p "tests"
cp "/tests/ini.rs" "tests/ini.rs"
mkdir -p "tests"
cp "/tests/issues.rs" "tests/issues.rs"

# Run the specific test files from the PR
cargo test --test fnmut --test ini --test issues -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
