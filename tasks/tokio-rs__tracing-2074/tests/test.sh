#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing/test-log-support/tests"
cp "/tests/tracing/test-log-support/tests/log_no_trace.rs" "tracing/test-log-support/tests/log_no_trace.rs"
mkdir -p "tracing/test-log-support/tests"
cp "/tests/tracing/test-log-support/tests/log_with_trace.rs" "tracing/test-log-support/tests/log_with_trace.rs"
mkdir -p "tracing/test-log-support/tests"
cp "/tests/tracing/test-log-support/tests/span_activity_filtered_separately.rs" "tracing/test-log-support/tests/span_activity_filtered_separately.rs"
mkdir -p "tracing/test-log-support/tests"
cp "/tests/tracing/test-log-support/tests/span_lifecycle_can_be_enabled.rs" "tracing/test-log-support/tests/span_lifecycle_can_be_enabled.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/future_send.rs" "tracing/tests/future_send.rs"

# Fetch dependencies (in case fix.patch added new ones)
cargo fetch 2>&1

# Clean all build artifacts to force full rebuild
cargo clean 2>&1

# Build and test tracing package
cargo build -p tracing --tests 2>&1
build_status=$?
if [ $build_status -ne 0 ]; then
    test_status=1
else
    cargo test -p tracing --tests -- --nocapture 2>&1
    tracing_status=$?

    # Build and test test-log-support package (separate workspace)
    cd tracing/test-log-support
    cargo fetch 2>&1
    cargo clean 2>&1
    cargo build --tests 2>&1
    build_status=$?
    if [ $build_status -ne 0 ]; then
        test_log_status=1
    else
        cargo test --tests -- --nocapture 2>&1
        test_log_status=$?
    fi
    cd /app/src

    if [ $tracing_status -ne 0 ] || [ $test_log_status -ne 0 ]; then
        test_status=1
    else
        test_status=0
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
