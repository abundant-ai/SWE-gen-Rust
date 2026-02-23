#!/bin/bash

cd /app/src

mkdir -p "tracing-opentelemetry/tests"
cp "/tests/tracing-opentelemetry/tests/metrics_publishing.rs" "tracing-opentelemetry/tests/metrics_publishing.rs"
mkdir -p "tracing-opentelemetry/tests"
cp "/tests/tracing-opentelemetry/tests/trace_state_propagation.rs" "tracing-opentelemetry/tests/trace_state_propagation.rs"

cargo build --workspace --tests
cargo test -p tracing-opentelemetry --test metrics_publishing -- --nocapture && \
cargo test -p tracing-opentelemetry --test trace_state_propagation -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
