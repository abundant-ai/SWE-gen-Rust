#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_display.rs" "tests/test_display.rs"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the specific test file
cargo test --test test_display
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
