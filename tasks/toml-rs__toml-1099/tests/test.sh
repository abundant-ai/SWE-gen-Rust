#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/general.rs" "crates/toml/tests/serde/general.rs"

# Run the specific test file for this PR
# This PR modifies crates/toml/tests/serde/general.rs
cargo test --test serde -p toml
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
