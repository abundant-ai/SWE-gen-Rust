#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Temporarily move all other test files out of the way to run only the tests for this PR
mkdir -p /tmp/other_tests
mv tests/fixtures/invalid/*.toml tests/fixtures/invalid/*.stderr /tmp/other_tests/ 2>/dev/null || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/key-two-equals.stderr" "tests/fixtures/invalid/key-two-equals.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-constant-like.stderr" "tests/fixtures/invalid/string-no-quotes-constant-like.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-array.stderr" "tests/fixtures/invalid/string-no-quotes-in-array.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-array.toml" "tests/fixtures/invalid/string-no-quotes-in-array.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-inline-table.stderr" "tests/fixtures/invalid/string-no-quotes-in-inline-table.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-inline-table.toml" "tests/fixtures/invalid/string-no-quotes-in-inline-table.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-table.stderr" "tests/fixtures/invalid/string-no-quotes-in-table.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/string-no-quotes-in-table.toml" "tests/fixtures/invalid/string-no-quotes-in-table.toml"

# Run the test_invalid test which processes the invalid fixtures
cargo test --test test_invalid -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
