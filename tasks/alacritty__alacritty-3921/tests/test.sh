#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/tests"
cp "/tests/alacritty_terminal/tests/ref.rs" "alacritty_terminal/tests/ref.rs"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor/alacritty.recording" "alacritty_terminal/tests/ref/saved_cursor/alacritty.recording"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor/config.json" "alacritty_terminal/tests/ref/saved_cursor/config.json"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor/grid.json" "alacritty_terminal/tests/ref/saved_cursor/grid.json"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor/size.json" "alacritty_terminal/tests/ref/saved_cursor/size.json"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor_alt"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor_alt/alacritty.recording" "alacritty_terminal/tests/ref/saved_cursor_alt/alacritty.recording"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor_alt"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor_alt/config.json" "alacritty_terminal/tests/ref/saved_cursor_alt/config.json"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor_alt"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor_alt/grid.json" "alacritty_terminal/tests/ref/saved_cursor_alt/grid.json"
mkdir -p "alacritty_terminal/tests/ref/saved_cursor_alt"
cp "/tests/alacritty_terminal/tests/ref/saved_cursor_alt/size.json" "alacritty_terminal/tests/ref/saved_cursor_alt/size.json"

# Run tests in the alacritty_terminal package
cargo test --package alacritty_terminal -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
