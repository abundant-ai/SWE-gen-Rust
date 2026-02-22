#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/easy_decoder.rs" "tests/easy_decoder.rs"
mkdir -p "tests"
cp "/tests/easy_encoder_compliance.rs" "tests/easy_encoder_compliance.rs"

# Run the specific tests from the PR (with easy feature enabled)
cargo test --test easy_decoder --test easy_encoder_compliance --features easy -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
