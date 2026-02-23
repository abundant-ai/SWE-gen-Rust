#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/mod.rs" "axum/src/routing/tests/mod.rs"

# Run the routing tests in axum package
cargo test -p axum --lib routing::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
