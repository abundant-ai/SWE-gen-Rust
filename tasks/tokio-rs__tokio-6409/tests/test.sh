#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-stream/tests"
cp "/tests/tokio-stream/tests/stream_stream_map.rs" "tokio-stream/tests/stream_stream_map.rs"

# Run the specific integration test
cd tokio-stream
timeout 300 cargo test --test stream_stream_map --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
