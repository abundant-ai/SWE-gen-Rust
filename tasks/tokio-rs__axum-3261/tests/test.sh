#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/from_request/pass"
cp "/tests/axum-macros/tests/from_request/pass/container.rs" "axum-macros/tests/from_request/pass/container.rs"
mkdir -p "axum-macros/tests/from_request/pass"
cp "/tests/axum-macros/tests/from_request/pass/container_parts.rs" "axum-macros/tests/from_request/pass/container_parts.rs"

# Run the ui test with AXUM_TEST_ONLY to filter for specific files
cd /app/src/axum-macros
AXUM_TEST_ONLY="axum-macros/tests/from_request/pass/container.rs" cargo test ui -- --nocapture
test_status_1=$?
AXUM_TEST_ONLY="axum-macros/tests/from_request/pass/container_parts.rs" cargo test ui -- --nocapture
test_status_2=$?

# Both tests must pass
if [ $test_status_1 -eq 0 ] && [ $test_status_2 -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
