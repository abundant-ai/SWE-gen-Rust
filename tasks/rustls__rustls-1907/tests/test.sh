#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"

# Run only the newly added test that validates the fix, with a timeout
# The test will hang with the bug present, so we use timeout to fail it
# Timeout of 60s should be enough for compilation and test execution
timeout 60 cargo test --test api test_complete_io_errors_if_close_notify_received_too_early -- --nocapture
test_status=$?

# timeout returns 124 if the command times out, which we treat as a test failure
if [ $test_status -eq 124 ]; then
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
