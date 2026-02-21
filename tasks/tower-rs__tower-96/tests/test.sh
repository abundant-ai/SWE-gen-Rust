#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-retry/tests"
cp "/tests/tower-retry/tests/retry.rs" "tower-retry/tests/retry.rs"

# Work around workspace Cargo.toml issue with [dev-dependencies] - move to subdirectory and rename
mv Cargo.toml Cargo.toml.workspace
cd tower-retry

# Run tests to validate the retry implementation
cargo test --test retry
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
