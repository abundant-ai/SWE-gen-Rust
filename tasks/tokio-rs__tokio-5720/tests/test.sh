#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/loom_pool.rs" "tokio/src/runtime/tests/loom_pool.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/loom_queue.rs" "tokio/src/runtime/tests/loom_queue.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_threaded.rs" "tokio/tests/rt_threaded.rs"

# Run the specific runtime tests and rt_threaded test
cd tokio
timeout 300 cargo test --lib runtime::tests --features full -- --nocapture
lib_status=$?

timeout 300 cargo test --test rt_threaded --features full -- --nocapture
test_status=$?

# Return success only if both pass
if [ $lib_status -eq 0 ] && [ $test_status -eq 0 ]; then
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
