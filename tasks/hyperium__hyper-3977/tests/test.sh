#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
# No test files to copy

# This PR removes the ready_stream test. In BASE state (with bug.patch applied),
# the ready_stream test exists. In the fixed state (after fix.patch), it's removed.
# We verify the fix by checking that the ready_stream test entry is NOT in Cargo.toml
# (indicating the problematic code and its test were successfully removed).

if grep -q "name = \"ready_stream\"" Cargo.toml; then
    # BASE state: ready_stream test still registered (has the problematic code)
    echo "ready_stream test found in Cargo.toml - this is the buggy state"
    test_status=1
else
    # Fixed state: ready_stream test removed (problematic code reverted)
    echo "ready_stream test not found in Cargo.toml - fix applied successfully"
    test_status=0
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
