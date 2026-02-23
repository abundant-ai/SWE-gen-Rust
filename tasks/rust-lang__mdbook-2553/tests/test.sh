#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/search.goml" "tests/gui/search.goml"

# Run the specific GUI test (runner.rs filters by file name)
export RUST_BACKTRACE=full
cargo test --test gui search -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
