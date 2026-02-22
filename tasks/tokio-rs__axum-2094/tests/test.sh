#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/mod.rs" "axum/src/routing/tests/mod.rs"

# Run the specific test that verifies the performance fix
# This test checks that state isn't cloned too much (should be 4 times, not 5)
cargo test -p axum --lib routing::tests::state_isnt_cloned_too_much -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
