#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests/tracing-instrumentation/tests"
cp "/tests/tokio/tests/tracing-instrumentation/tests/task.rs" "tokio/tests/tracing-instrumentation/tests/task.rs"

# Run the tracing-instrumentation task test with tokio_unstable cfg
cd tokio/tests/tracing-instrumentation
export RUSTFLAGS="$RUSTFLAGS --cfg tokio_unstable"
cargo test --test task -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
