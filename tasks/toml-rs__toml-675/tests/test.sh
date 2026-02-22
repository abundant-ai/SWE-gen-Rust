#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/parse.rs" "crates/toml_edit/tests/testsuite/parse.rs"

# Run the parse tests from the testsuite test target
output=$(cargo test -p toml_edit --test testsuite -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if the tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  # No tests ran - this is a failure in HEAD state where tests should exist
  echo "ERROR: No tests ran. The parse tests should exist." >&2
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
