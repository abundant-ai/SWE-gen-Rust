#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/loom_yield.rs" "tokio/src/runtime/tests/loom_yield.rs"
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/mod.rs" "tokio/src/runtime/tests/mod.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_common.rs" "tokio/tests/rt_common.rs"

# Run the specific integration test
cd tokio
timeout 300 cargo test --test rt_common --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
