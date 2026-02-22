#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/fallback.rs" "axum/src/routing/tests/fallback.rs"

# Run the specific tests that were added in this PR (issue #2072)
# These tests verify that nested router fallbacks are preserved during merge operations
cargo test -p axum --lib routing::tests::fallback::issue_2072 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
