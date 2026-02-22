#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"

# Run the specific test file for this PR
cargo test --package rustls --test api 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
