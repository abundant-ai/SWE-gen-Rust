#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/time/tests"
cp "/tests/tokio/src/runtime/time/tests/mod.rs" "tokio/src/runtime/time/tests/mod.rs"

# Run the specific unit tests in the runtime::time::tests module
cd tokio
timeout 300 cargo test --lib --features full runtime::time::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
