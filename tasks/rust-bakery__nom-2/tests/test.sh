#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/ini.rs" "tests/ini.rs"
mkdir -p "tests"
cp "/tests/mp4.rs" "tests/mp4.rs"
mkdir -p "tests"
cp "/tests/omnom.rs" "tests/omnom.rs"
mkdir -p "tests"
cp "/tests/test1.rs" "tests/test1.rs"

# Run the specific test files for this PR
cargo test --test ini -- --nocapture && \
cargo test --test mp4 -- --nocapture && \
cargo test --test omnom -- --nocapture && \
cargo test --test test1 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
