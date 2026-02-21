#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/tests"
cp "/tests/alacritty_terminal/tests/ref.rs" "alacritty_terminal/tests/ref.rs"
mkdir -p "alacritty_terminal/tests/ref/clear_underline"
cp "/tests/alacritty_terminal/tests/ref/clear_underline/alacritty.recording" "alacritty_terminal/tests/ref/clear_underline/alacritty.recording"
mkdir -p "alacritty_terminal/tests/ref/clear_underline"
cp "/tests/alacritty_terminal/tests/ref/clear_underline/config.json" "alacritty_terminal/tests/ref/clear_underline/config.json"
mkdir -p "alacritty_terminal/tests/ref/clear_underline"
cp "/tests/alacritty_terminal/tests/ref/clear_underline/grid.json" "alacritty_terminal/tests/ref/clear_underline/grid.json"
mkdir -p "alacritty_terminal/tests/ref/clear_underline"
cp "/tests/alacritty_terminal/tests/ref/clear_underline/size.json" "alacritty_terminal/tests/ref/clear_underline/size.json"

# Run only the clear_underline test (other ref tests may fail on old commits)
cargo test --package alacritty_terminal --test ref clear_underline -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
