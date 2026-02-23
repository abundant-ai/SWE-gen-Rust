#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/build_analysis.rs" "tests/testsuite/build_analysis.rs"

# Run specific test for the PR
# Test: build_analysis::log_msg_unit_graph
cargo test -p cargo --test testsuite build_analysis::log_msg_unit_graph -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
