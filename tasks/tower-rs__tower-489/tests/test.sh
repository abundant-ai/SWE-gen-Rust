#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests/balance"
cp "/tests/tower/tests/balance/main.rs" "tower/tests/balance/main.rs"
mkdir -p "tower/tests"
cp "/tests/tower/tests/support.rs" "tower/tests/support.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/call_all.rs" "tower/tests/util/call_all.rs"

# Run the specific integration test
cargo test --test balance --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
