#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Rebuild axum-macros to pick up any changes from fix.patch
cargo build -p axum-macros 2>&1 | head -20 || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/debug_handler/fail"
cp "/tests/axum-macros/tests/debug_handler/fail/wrong_return_type.stderr" "axum-macros/tests/debug_handler/fail/wrong_return_type.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/generic_without_via.stderr" "axum-macros/tests/from_request/fail/generic_without_via.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/generic_without_via_rejection.stderr" "axum-macros/tests/from_request/fail/generic_without_via_rejection.stderr"
mkdir -p "axum-macros/tests/from_request/fail"
cp "/tests/axum-macros/tests/from_request/fail/override_rejection_on_enum_without_via.stderr" "axum-macros/tests/from_request/fail/override_rejection_on_enum_without_via.stderr"
mkdir -p "axum-macros/tests/typed_path/fail"
cp "/tests/axum-macros/tests/typed_path/fail/not_deserialize.stderr" "axum-macros/tests/typed_path/fail/not_deserialize.stderr"
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/mod.rs" "axum/src/routing/tests/mod.rs"

# Run the routing tests (main functionality test)
# The key test is method_router_fallback_with_state which is a compile-time test
cargo test -p axum routing::tests --  --test-threads=1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
