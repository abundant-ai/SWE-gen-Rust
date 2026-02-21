#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/sync/tests"
cp "/tests/tokio/src/sync/tests/loom_notify.rs" "tokio/src/sync/tests/loom_notify.rs"
mkdir -p "tokio/src/sync/tests"
cp "/tests/tokio/src/sync/tests/notify.rs" "tokio/src/sync/tests/notify.rs"

# Run the specific tests for notify module
cd tokio
timeout 300 cargo test --lib sync::tests::loom_notify --features full -- --nocapture
notify_loom_status=$?

timeout 300 cargo test --lib sync::tests::notify --features full -- --nocapture
notify_status=$?

# Both tests must pass
if [ $notify_loom_status -eq 0 ] && [ $notify_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
