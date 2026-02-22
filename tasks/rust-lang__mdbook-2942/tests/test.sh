#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/config.rs" "tests/testsuite/config.rs"

# Run the specific config tests (using pattern matching)
cargo test --test testsuite env_ -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
