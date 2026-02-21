#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/src/grid"
cp "/tests/alacritty_terminal/src/grid/tests.rs" "alacritty_terminal/src/grid/tests.rs"

# Run the specific tests in the grid module
cargo test --package alacritty_terminal --lib grid::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
