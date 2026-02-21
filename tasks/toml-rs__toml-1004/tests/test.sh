#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_writer/tests"
cp "/tests/crates/toml_writer/tests/integer.rs" "crates/toml_writer/tests/integer.rs"

# Run tests for the integer test in toml_writer crate
cargo test -p toml_writer --test integer
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
