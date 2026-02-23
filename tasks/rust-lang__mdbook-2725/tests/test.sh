#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/sidebar.goml" "tests/gui/sidebar.goml"

# Run the GUI test using the Rust test runner with filter for sidebar test
cargo test --test gui -- sidebar
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
