#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/sync_mpsc.rs" "tokio/tests/sync_mpsc.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/sync_mpsc_weak.rs" "tokio/tests/sync_mpsc_weak.rs"

# Run the specific integration tests
timeout 300 cargo test --test sync_mpsc --test sync_mpsc_weak --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
