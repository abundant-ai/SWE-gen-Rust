#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/src/grid"
cp "/tests/alacritty_terminal/src/grid/tests.rs" "alacritty_terminal/src/grid/tests.rs"

# Run only grid tests (excludes integration tests that may fail on old commits)
cargo test --package alacritty_terminal --lib grid:: -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
