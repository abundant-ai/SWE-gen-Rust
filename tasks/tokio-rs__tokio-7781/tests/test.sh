#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/tcp_socket.rs" "tokio/tests/tcp_socket.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/udp.rs" "tokio/tests/udp.rs"

# Run the specific tests for both tcp_socket and udp with required features
cd tokio
cargo test --test tcp_socket --features full && cargo test --test udp --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
