#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/argument_not_extractor.stderr" "axum-macros/tests/debug_handler/fail/argument_not_extractor.stderr"
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/extension_not_clone.stderr" "axum-macros/tests/debug_handler/fail/extension_not_clone.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/generic_without_via.stderr" "axum-macros/tests/from_request/fail/generic_without_via.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/generic_without_via_rejection.stderr" "axum-macros/tests/from_request/fail/generic_without_via_rejection.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/override_rejection_on_enum_without_via.stderr" "axum-macros/tests/from_request/fail/override_rejection_on_enum_without_via.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/parts_extracting_body.stderr" "axum-macros/tests/from_request/fail/parts_extracting_body.stderr"

# Run the trybuild tests for debug_handler and from_request
# The stderr files are expected compiler error outputs for compile-fail tests
cd /app/src/axum-macros
cargo test --lib ui_debug_handler -- --nocapture && cargo test --lib ui -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
