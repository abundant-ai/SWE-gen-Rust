#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/io_read_to_end.rs" "tokio/tests/io_read_to_end.rs"

# Run the specific io_read_to_end integration test
cd tokio
timeout 300 cargo test --test io_read_to_end --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
