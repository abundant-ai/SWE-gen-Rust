#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests/layer_filters"
cp "/tests/tracing-subscriber/tests/layer_filters/main.rs" "tracing-subscriber/tests/layer_filters/main.rs"
mkdir -p "tracing-subscriber/tests/layer_filters"
cp "/tests/tracing-subscriber/tests/layer_filters/vec.rs" "tracing-subscriber/tests/layer_filters/vec.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/vec_subscriber_filter_interests_cached.rs" "tracing-subscriber/tests/vec_subscriber_filter_interests_cached.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/enabled.rs" "tracing/tests/enabled.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/macros.rs" "tracing/tests/macros.rs"

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

    # Build and test tracing-subscriber package
    cargo build -p tracing-subscriber --tests 2>&1
    build_status=$?
    if [ $build_status -ne 0 ]; then
        subscriber_status=1
    else
        cargo test -p tracing-subscriber --tests -- --nocapture 2>&1
        subscriber_status=$?
    fi

    if [ $tracing_status -ne 0 ] || [ $subscriber_status -ne 0 ]; then
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
