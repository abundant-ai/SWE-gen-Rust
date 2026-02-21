#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/help.rs" "tests/builder/help.rs"

# Run only the specific tests from the help.rs file (in the builder test module)
# The specific tests that were added/modified are: flatten_single_hidden_command, flatten_hidden_command, flatten_recursive
output=$(cargo test --test builder flatten --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if any tests actually ran (the tests should exist in the fixed version)
if echo "$output" | grep -q "running 0 tests"; then
    echo "ERROR: No tests were run. The expected tests are missing."
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
