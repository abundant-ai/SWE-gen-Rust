#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/abort_on_drop.rs" "tokio-util/tests/abort_on_drop.rs"

# Run the abort_on_drop test with timeout
timeout 300 cargo test --test abort_on_drop -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
