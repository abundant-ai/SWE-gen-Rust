#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-filter/tests"
cp "/tests/tower-filter/tests/filter.rs" "tower-filter/tests/filter.rs"

# Run specific test for the tower-filter fix
# Note: Only running rejected_sync test as other tests use futures 0.1 Task which panics on Rust 1.70
cargo test --test filter --manifest-path tower-filter/Cargo.toml rejected_sync
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
