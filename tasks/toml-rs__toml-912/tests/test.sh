#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_datetime/tests"
cp "/tests/crates/toml_datetime/tests/parse.rs" "crates/toml_datetime/tests/parse.rs"

# Run tests for the parse test in the toml_datetime package
cargo test -p toml_datetime --test parse
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
