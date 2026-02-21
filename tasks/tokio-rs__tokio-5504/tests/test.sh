#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_join.rs" "tokio/tests/macros_join.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_try_join.rs" "tokio/tests/macros_try_join.rs"

# Run the specific integration tests for macros_join and macros_try_join
cd tokio
timeout 300 cargo test --test macros_join --test macros_try_join --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
