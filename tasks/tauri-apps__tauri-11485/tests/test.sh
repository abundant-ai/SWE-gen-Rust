#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/tauri/test/fixture/src-tauri"
cp "/tests/crates/tauri/test/fixture/src-tauri/tauri.conf.json" "crates/tauri/test/fixture/src-tauri/tauri.conf.json"

# Run the test that uses the fixture config
cargo test --package tauri --lib test::tests::run_app -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
