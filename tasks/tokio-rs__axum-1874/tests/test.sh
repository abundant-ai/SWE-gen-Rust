#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/from_ref/fail"
cp "/tests/axum-macros/tests/from_ref/fail/generics.rs" "axum-macros/tests/from_ref/fail/generics.rs"
mkdir -p "axum-macros/tests/from_ref/fail"
cp "/tests/axum-macros/tests/from_ref/fail/generics.stderr" "axum-macros/tests/from_ref/fail/generics.stderr"

# Run the UI tests for from_ref (trybuild compile-fail tests)
cargo test -p axum-macros --lib from_ref::ui -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
