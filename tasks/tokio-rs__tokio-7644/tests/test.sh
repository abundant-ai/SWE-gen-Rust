#!/bin/bash

cd /app/src

# Set environment variables for tests (loom configuration)
export RUSTFLAGS="-Dwarnings --cfg loom --cfg tokio_unstable -C debug_assertions"
export LOOM_MAX_PREEMPTIONS=2
export LOOM_MAX_BRANCHES=10000
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/src/sync/tests"
cp "/tests/tokio-util/src/sync/tests/loom_cancellation_token.rs" "tokio-util/src/sync/tests/loom_cancellation_token.rs"
mkdir -p "tokio-util/src/sync/tests"
cp "/tests/tokio-util/src/sync/tests/mod.rs" "tokio-util/src/sync/tests/mod.rs"
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/udp.rs" "tokio-util/tests/udp.rs"

# Run the specific test files for this PR
cd tokio-util
cargo test --lib --release --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
