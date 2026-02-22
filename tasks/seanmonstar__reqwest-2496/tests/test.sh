#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/connector_layers.rs" "tests/connector_layers.rs"
mkdir -p "tests/support"
cp "/tests/support/delay_layer.rs" "tests/support/delay_layer.rs"
mkdir -p "tests/support"
cp "/tests/support/mod.rs" "tests/support/mod.rs"
mkdir -p "tests"
cp "/tests/timeouts.rs" "tests/timeouts.rs"

# Run tests for the specific test files
cargo test --test connector_layers --test timeouts -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
