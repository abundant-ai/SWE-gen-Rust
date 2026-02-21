#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_config_derive/tests"
cp "/tests/alacritty_config_derive/tests/config.rs" "alacritty_config_derive/tests/config.rs"

# Run tests in the alacritty_config_derive package
cargo test --package alacritty_config_derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
