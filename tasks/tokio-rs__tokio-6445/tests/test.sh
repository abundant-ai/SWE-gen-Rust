#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_panic.rs" "tokio/tests/rt_panic.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_threaded.rs" "tokio/tests/rt_threaded.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_threaded_alt.rs" "tokio/tests/rt_threaded_alt.rs"

# Run the specific integration tests
cd tokio
timeout 300 cargo test --test rt_panic --test rt_threaded --test rt_threaded_alt --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
