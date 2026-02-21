#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/tests"
cp "/tests/alacritty_terminal/tests/ref.rs" "alacritty_terminal/tests/ref.rs"
mkdir -p "alacritty_terminal/tests/ref/origin_goto"
cp "/tests/alacritty_terminal/tests/ref/origin_goto/alacritty.recording" "alacritty_terminal/tests/ref/origin_goto/alacritty.recording"
mkdir -p "alacritty_terminal/tests/ref/origin_goto"
cp "/tests/alacritty_terminal/tests/ref/origin_goto/config.json" "alacritty_terminal/tests/ref/origin_goto/config.json"
mkdir -p "alacritty_terminal/tests/ref/origin_goto"
cp "/tests/alacritty_terminal/tests/ref/origin_goto/grid.json" "alacritty_terminal/tests/ref/origin_goto/grid.json"
mkdir -p "alacritty_terminal/tests/ref/origin_goto"
cp "/tests/alacritty_terminal/tests/ref/origin_goto/size.json" "alacritty_terminal/tests/ref/origin_goto/size.json"

# Run the specific origin_goto test from ref.rs
cargo test origin_goto -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
