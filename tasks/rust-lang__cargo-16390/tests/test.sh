#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/build_analysis.rs" "tests/testsuite/build_analysis.rs"
mkdir -p "tests/testsuite/cargo_report_timings/html_snapshot/in/cargo-home/log"
cp "/tests/testsuite/cargo_report_timings/html_snapshot/in/cargo-home/log/20060724T012128000Z-b0fd440798ab3cfb.jsonl" "tests/testsuite/cargo_report_timings/html_snapshot/in/cargo-home/log/20060724T012128000Z-b0fd440798ab3cfb.jsonl"
mkdir -p "tests/testsuite/cargo_report_timings/html_snapshot/out"
cp "/tests/testsuite/cargo_report_timings/html_snapshot/out/cargo-timing-20060724T012128000Z-b0fd440798ab3cfb.html" "tests/testsuite/cargo_report_timings/html_snapshot/out/cargo-timing-20060724T012128000Z-b0fd440798ab3cfb.html"

# Run specific test for the PR - build_analysis
cargo test -p cargo --test testsuite build_analysis -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
