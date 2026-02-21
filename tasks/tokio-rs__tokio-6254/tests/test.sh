#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/io_repeat.rs" "tokio/tests/io_repeat.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/io_sink.rs" "tokio/tests/io_sink.rs"

# Run the specific integration tests
cd tokio
timeout 300 cargo test --test io_repeat --test io_sink --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
