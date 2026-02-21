#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="--cfg tokio_unstable -Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-stream/tests"
cp "/tests/tokio-stream/tests/mpsc_bounded_stream.rs" "tokio-stream/tests/mpsc_bounded_stream.rs"
mkdir -p "tokio-stream/tests"
cp "/tests/tokio-stream/tests/mpsc_unbounded_stream.rs" "tokio-stream/tests/mpsc_unbounded_stream.rs"

# Run the specific test files for this PR
cd tokio-stream
cargo test --test mpsc_bounded_stream --features full && cargo test --test mpsc_unbounded_stream --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
