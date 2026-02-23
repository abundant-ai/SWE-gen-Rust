#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/err.rs" "tracing-attributes/tests/err.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/ret.rs" "tracing-attributes/tests/ret.rs"
mkdir -p "tracing-subscriber/tests/layer_filters"
cp "/tests/tracing-subscriber/tests/layer_filters/vec.rs" "tracing-subscriber/tests/layer_filters/vec.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/option.rs" "tracing-subscriber/tests/option.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/vec.rs" "tracing-subscriber/tests/vec.rs"

# Fetch dependencies (in case fix.patch added new ones)
cargo fetch 2>&1

# Clean all build artifacts to force full rebuild (needed for proc-macro and lib changes)
cargo clean 2>&1

# Build tracing-subscriber first (needed as dependency for tracing-attributes tests)
cargo build -p tracing-subscriber --lib 2>&1
build_status=$?
if [ $build_status -ne 0 ]; then
    test_status=1
    if [ $test_status -eq 0 ]; then
      echo 1 > /logs/verifier/reward.txt
    else
      echo 0 > /logs/verifier/reward.txt
    fi
    exit "$test_status"
fi

# Build and test tracing-attributes
cargo build -p tracing-attributes --tests 2>&1
build_status=$?
if [ $build_status -ne 0 ]; then
    test_status=1
else
    cargo test -p tracing-attributes --test err -- --nocapture --skip test_err_custom_target
    test_status=$?
    if [ $test_status -eq 0 ]; then
        cargo test -p tracing-attributes --test ret -- --nocapture --skip test_custom_target
        test_status=$?
    fi
fi

# Build and test tracing-subscriber if tracing-attributes tests passed
if [ $test_status -eq 0 ]; then
    cargo build -p tracing-subscriber --tests 2>&1
    build_status=$?
    if [ $build_status -ne 0 ]; then
        test_status=1
    else
        cargo test -p tracing-subscriber --test option -- --nocapture
        test_status=$?
        if [ $test_status -eq 0 ]; then
            cargo test -p tracing-subscriber --test vec -- --nocapture
            test_status=$?
        fi
        if [ $test_status -eq 0 ]; then
            cargo test -p tracing-subscriber --test layer_filters -- --nocapture
            test_status=$?
        fi
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
