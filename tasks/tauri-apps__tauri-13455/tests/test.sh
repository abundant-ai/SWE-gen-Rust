#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/tauri/src/test"
cp "/tests/crates/tauri/src/test/mod.rs" "crates/tauri/src/test/mod.rs"

# Run the tests in the test module
cargo test --package tauri --lib test::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
