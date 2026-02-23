#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/async_fn.rs" "tracing-attributes/tests/async_fn.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/destructuring.rs" "tracing-attributes/tests/destructuring.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/err.rs" "tracing-attributes/tests/err.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/fields.rs" "tracing-attributes/tests/fields.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/instrument.rs" "tracing-attributes/tests/instrument.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/main.rs" "tracing-subscriber/tests/env_filter/main.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/per_subscriber.rs" "tracing-subscriber/tests/env_filter/per_subscriber.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/same_len_filters.rs" "tracing-subscriber/tests/same_len_filters.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/collector.rs" "tracing/tests/collector.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/span.rs" "tracing/tests/span.rs"

# Run tests for the specific test files from this PR
cd /app/src/tracing-attributes && cargo test --test async_fn -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test destructuring -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test err -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test fields -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test instrument -- --nocapture && \
cd /app/src/tracing-subscriber && cargo test --test env_filter -- --nocapture && \
cd /app/src/tracing-subscriber && cargo test --test same_len_filters -- --nocapture && \
cd /app/src/tracing && cargo test --test collector -- --nocapture && \
cd /app/src/tracing && cargo test --test span -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
