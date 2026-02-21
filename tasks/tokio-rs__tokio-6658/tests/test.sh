#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-stream/tests"
cp "/tests/tokio-stream/tests/stream_chain.rs" "tokio-stream/tests/stream_chain.rs"

# Rebuild the tokio-stream package to pick up any changes from fix.patch
cd tokio-stream
cargo build --features full
cd ..

# Run only the specific test file for this PR (stream_chain)
cd tokio-stream
timeout 300 cargo test --test stream_chain --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
