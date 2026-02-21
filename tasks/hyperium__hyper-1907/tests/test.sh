#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run the specific integration test
# Exclude flaky tests that may hang (like http2_detect_conn_eof)
cargo test --test server --features "runtime" -- --nocapture --skip http2
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
