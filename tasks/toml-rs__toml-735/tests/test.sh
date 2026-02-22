#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_edit/tests/fixtures/invalid/datetime"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/datetime/offset-overflow-hour.stderr" "crates/toml_edit/tests/fixtures/invalid/datetime/offset-overflow-hour.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/datetime"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/datetime/offset-overflow-minute.stderr" "crates/toml_edit/tests/fixtures/invalid/datetime/offset-overflow-minute.stderr"

# Run the invalid test with filters for the specific datetime offset tests
output=$(cargo test -p toml_edit --test invalid -- offset-overflow --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if the tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  # No tests ran - this is a failure in HEAD state where tests should exist
  echo "ERROR: No tests ran. The offset-overflow tests should exist." >&2
  echo 0 > /logs/verifier/reward.txt
  exit 1
elif [ $test_status -eq 0 ]; then
  # Tests ran and passed
  echo 1 > /logs/verifier/reward.txt
  exit 0
else
  # Tests ran but failed
  echo 0 > /logs/verifier/reward.txt
  exit 1
fi
