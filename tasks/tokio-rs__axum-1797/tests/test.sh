#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Rebuild axum-macros to pick up any changes from fix.patch
cargo build -p axum-macros 2>&1 | head -20 || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/multiple_request_consumers.rs" "axum-macros/tests/debug_handler/fail/multiple_request_consumers.rs"
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/multiple_request_consumers.stderr" "axum-macros/tests/debug_handler/fail/multiple_request_consumers.stderr"
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/wrong_order.rs" "axum-macros/tests/debug_handler/fail/wrong_order.rs"
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/wrong_order.stderr" "axum-macros/tests/debug_handler/fail/wrong_order.stderr"

# Remove test files that don't exist in HEAD state (created by bug.patch)
rm -f "axum-macros/tests/debug_handler/fail/doesnt_implement_from_request_parts.rs"
rm -f "axum-macros/tests/debug_handler/fail/doesnt_implement_from_request_parts.stderr"

# Run only the specific UI tests added by this PR using AXUM_TEST_ONLY env var
export AXUM_TEST_ONLY="tests/debug_handler/fail/multiple_request_consumers.rs"
cargo test -p axum-macros debug_handler::ui && \
export AXUM_TEST_ONLY="tests/debug_handler/fail/wrong_order.rs" && \
cargo test -p axum-macros debug_handler::ui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
