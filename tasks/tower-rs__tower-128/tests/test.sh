#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-filter/tests"
cp "/tests/tower-filter/tests/filter.rs" "tower-filter/tests/filter.rs"

# Work around workspace Cargo.toml issue with [dev-dependencies] - move to subdirectory and rename
mv Cargo.toml Cargo.toml.workspace
cd tower-filter

# Run tests to validate the filter implementation
cargo test --test filter
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
