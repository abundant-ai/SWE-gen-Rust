#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests/ready_cache"
cp "/tests/tower/tests/ready_cache/main.rs" "tower/tests/ready_cache/main.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/call_all.rs" "tower/tests/util/call_all.rs"

# Run the specific integration tests
cargo test --test ready_cache --test util --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
