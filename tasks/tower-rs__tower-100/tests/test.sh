#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-rate-limit/tests"
cp "/tests/tower-rate-limit/tests/rate_limit.rs" "tower-rate-limit/tests/rate_limit.rs"

# Work around workspace Cargo.toml issue with [dev-dependencies] - move to subdirectory and rename
mv Cargo.toml Cargo.toml.workspace
cd tower-rate-limit

# Run tests to validate the rate limit implementation
cargo test --test rate_limit
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
