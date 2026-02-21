#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Run the test that checks for --fixed-strings suggestion
# The bug.patch adds back the suggestion code and this test
# In BUG state: suggestion exists, test passes
# In HEAD state (with fix): suggestion removed, test fails
cargo test suggest_fixed_strings_for_invalid_regex -- --nocapture
test_status=$?

# Invert the result - we want failure (no suggestion) to be the correct state
# The fix intentionally removed the --fixed-strings suggestion from error messages
if [ $test_status -eq 0 ]; then
  # Test passed (suggestion exists) - this is the BUG state
  echo 0 > /logs/verifier/reward.txt
  exit 1
else
  # Test failed (no suggestion) - this is the FIX state
  echo 1 > /logs/verifier/reward.txt
  exit 0
fi
