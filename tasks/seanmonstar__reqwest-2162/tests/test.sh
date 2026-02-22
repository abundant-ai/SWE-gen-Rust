#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy BASE test files from /tests (tests without feature gates)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run client tests with http2 feature
# Oracle applies fix.patch which adds the http2 feature, allowing tests to pass
# NOP doesn't apply fix, so http2 feature doesn't exist and tests fail
cargo test --test client --features http2 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
