#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS='--cfg hyper_unstable_tracing'

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/ready_stream.rs" "tests/ready_stream.rs"

# Run the specific test file for this PR
cargo test --test ready_stream --features full,tracing -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
