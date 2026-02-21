#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/tcp_connect.rs" "tokio/tests/tcp_connect.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/tcp_shutdown.rs" "tokio/tests/tcp_shutdown.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/tcp_socket.rs" "tokio/tests/tcp_socket.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/tcp_stream.rs" "tokio/tests/tcp_stream.rs"

# Run the specific test files for this PR
cd tokio
cargo test --test tcp_connect --test tcp_shutdown --test tcp_socket --test tcp_stream --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
