#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Temporarily move all other test files out of the way to run only the tests for this PR
mkdir -p /tmp/other_tests
mv tests/fixtures/invalid/*.toml tests/fixtures/invalid/*.stderr /tmp/other_tests/ 2>/dev/null || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-key-dotted-into-std.stderr" "tests/fixtures/invalid/duplicate-key-dotted-into-std.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-key-std-into-dotted.stderr" "tests/fixtures/invalid/duplicate-key-std-into-dotted.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-key-table.stderr" "tests/fixtures/invalid/duplicate-key-table.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys-cargo.stderr" "tests/fixtures/invalid/duplicate-keys-cargo.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys-cargo.toml" "tests/fixtures/invalid/duplicate-keys-cargo.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys-dotted.stderr" "tests/fixtures/invalid/duplicate-keys-dotted.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys-dotted.toml" "tests/fixtures/invalid/duplicate-keys-dotted.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-keys.stderr" "tests/fixtures/invalid/duplicate-keys.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/duplicate-tables.stderr" "tests/fixtures/invalid/duplicate-tables.stderr"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/table-array-implicit.stderr" "tests/fixtures/invalid/table-array-implicit.stderr"

# Run the test_invalid test which processes the invalid fixtures
cargo test --test test_invalid -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
