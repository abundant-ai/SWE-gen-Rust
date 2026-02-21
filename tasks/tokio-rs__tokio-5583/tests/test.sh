#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/udp.rs" "tokio/tests/udp.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/uds_datagram.rs" "tokio/tests/uds_datagram.rs"

# Run the specific integration tests for udp and uds_datagram
cd tokio
timeout 300 cargo test --test udp --features full -- --nocapture && \
timeout 300 cargo test --test uds_datagram --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
