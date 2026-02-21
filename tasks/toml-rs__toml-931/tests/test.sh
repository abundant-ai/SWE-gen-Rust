#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/compliance"
cp "/tests/crates/toml/tests/compliance/main.rs" "crates/toml/tests/compliance/main.rs"

# Run tests for the compliance test in the toml package
cargo test -p toml --test compliance
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
