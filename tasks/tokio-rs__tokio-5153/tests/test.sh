#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"
export MIRIFLAGS="-Zmiri-disable-isolation"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio-util/src/sync/tests"
cp "/tests/tokio-util/src/sync/tests/loom_cancellation_token.rs" "tokio-util/src/sync/tests/loom_cancellation_token.rs"
mkdir -p "tokio-util/tests"
cp "/tests/tokio-util/tests/sync_cancellation_token.rs" "tokio-util/tests/sync_cancellation_token.rs"

# Run the specific tests for this PR
cd tokio-util
cargo test --test sync_cancellation_token --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
