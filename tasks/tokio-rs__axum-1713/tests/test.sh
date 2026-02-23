#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Rebuild axum to pick up any changes from fix.patch
cargo build -p axum 2>&1 | head -20 || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/argument_not_extractor.stderr" "axum-macros/tests/debug_handler/fail/argument_not_extractor.stderr"
cp "/tests/axum-macros/tests/debug_handler/fail/doesnt_implement_from_request_parts.stderr" "axum-macros/tests/debug_handler/fail/doesnt_implement_from_request_parts.stderr"
cp "/tests/axum-macros/tests/debug_handler/fail/wrong_return_type.stderr" "axum-macros/tests/debug_handler/fail/wrong_return_type.stderr"

mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/parts_extracting_body.stderr" "axum-macros/tests/from_request/fail/parts_extracting_body.stderr"

# Run the raw_path_params test (main functionality test added in this PR)
# We need to verify that at least 1 test actually ran (0 tests means the test doesn't exist in BASE state)
test_output=$(cargo test -p axum raw_path_params -- --test-threads=1 2>&1)
test_status=$?
echo "$test_output"

# Check if at least one test ran (look for "1 passed" or similar, not "0 passed")
if echo "$test_output" | grep -q "0 passed"; then
    echo "ERROR: No tests ran - raw_path_params test doesn't exist"
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
