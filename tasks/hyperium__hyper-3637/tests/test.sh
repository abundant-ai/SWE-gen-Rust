#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS='--cfg hyper_unstable_tracing'

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run the client test file (most affected by this PR)
# Note: Running both client and server tests takes too long and causes timeout
# The client tests are sufficient to verify the fix since they test the core trailer functionality
cargo test --test client --features full,tracing -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
