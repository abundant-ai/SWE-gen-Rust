#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-util/tests"
cp "/tests/tower-util/tests/service_fn.rs" "tower-util/tests/service_fn.rs"

# Run the specific integration test for this PR
cargo test -p tower-util --test service_fn -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
