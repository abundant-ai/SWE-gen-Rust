#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/possible_values.rs" "tests/builder/possible_values.rs"

# Run only the specific tests affected by this PR
# The tests are: no_iterate_when_hidden and iterate_when_displayed (in the expensive module)
# These tests require the "string" feature to be enabled
output=$(cargo test --test builder --features string iterate --no-fail-fast -- --nocapture 2>&1)
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
