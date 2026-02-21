#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/tests/ref/underline"
cp "/tests/alacritty_terminal/tests/ref/underline/grid.json" "alacritty_terminal/tests/ref/underline/grid.json"
mkdir -p "alacritty_terminal/tests/ref/underline"
cp "/tests/alacritty_terminal/tests/ref/underline/size.json" "alacritty_terminal/tests/ref/underline/size.json"

# Run tests in the alacritty_terminal package
cargo test --package alacritty_terminal -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
