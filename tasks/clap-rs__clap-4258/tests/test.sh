#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# NOTE: This PR modifies test files as part of the fix (adding #[cfg(feature = "wrap_help")] guards).
# We do NOT copy HEAD test files, as BASE tests (without guards) are needed to verify the bug.

# Test the bug: wrap_help feature should depend on help feature.
# We enable wrap_help without enabling help directly (using --no-default-features).
# BASE (buggy): wrap_help doesn't pull in help → 0 tests run → failure
# HEAD (fixed): wrap_help pulls in help → tests run and pass
output=$(cargo test --test builder --no-default-features --features std,color,usage,wrap_help help -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if any tests actually ran (output should contain "running N tests" where N > 0)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No tests ran! This means the help feature wasn't enabled." >&2
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
