#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/decoder.rs" "tests/decoder.rs"
mkdir -p "tests"
cp "/tests/decoder_compliance.rs" "tests/decoder_compliance.rs"
mkdir -p "tests"
cp "/tests/encoder_compliance.rs" "tests/encoder_compliance.rs"

# Rebuild tests after copying new test files
cargo build --workspace --all-targets 2>&1

# Run the specific tests from the PR
cargo test --test decoder 2>&1
decoder_status=$?

cargo test --test decoder_compliance 2>&1
decoder_compliance_status=$?

cargo test --test encoder_compliance 2>&1
encoder_compliance_status=$?

# Decoder and encoder_compliance must pass (decoder_compliance has expected failures)
if [ $decoder_status -eq 0 ] && [ $encoder_compliance_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
