#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/abort_on_drop.rs" "tokio-util/tests/abort_on_drop.rs"

# Run the specific test for abort_on_drop with required features
cd tokio-util
cargo test --test abort_on_drop --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
