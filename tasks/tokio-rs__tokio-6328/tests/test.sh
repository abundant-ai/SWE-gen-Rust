#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/dump.rs" "tokio/tests/dump.rs"

# Run the specific integration test (dump.rs requires tokio_unstable and tokio_taskdump features)
cd tokio
timeout 300 cargo test --test dump --features full --config 'build.rustflags=["--cfg", "tokio_unstable", "--cfg", "tokio_taskdump"]' -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
