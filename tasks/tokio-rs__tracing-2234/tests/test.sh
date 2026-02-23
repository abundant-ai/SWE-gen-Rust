#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-opentelemetry/tests"
cp "/tests/tracing-opentelemetry/tests/metrics_publishing.rs" "tracing-opentelemetry/tests/metrics_publishing.rs"

cargo build -p tracing-opentelemetry --tests --features metrics 2>&1
build_status=$?
if [ $build_status -ne 0 ]; then
    test_status=1
else
    cargo test -p tracing-opentelemetry --test metrics_publishing --features metrics -- --nocapture
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
