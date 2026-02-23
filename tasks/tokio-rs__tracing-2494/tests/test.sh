#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/per_subscriber.rs" "tracing-subscriber/tests/env_filter/per_subscriber.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/filter_scopes.rs" "tracing-subscriber/tests/subscriber_filters/filter_scopes.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/main.rs" "tracing-subscriber/tests/subscriber_filters/main.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/targets.rs" "tracing-subscriber/tests/subscriber_filters/targets.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/trees.rs" "tracing-subscriber/tests/subscriber_filters/trees.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/event.rs" "tracing/tests/event.rs"

# Run tests for the specific test files from this PR
# env_filter and subscriber_filters are multi-file integration tests
cd /app/src/tracing-subscriber && cargo test --test env_filter -- --nocapture && \
cd /app/src/tracing-subscriber && cargo test --test subscriber_filters -- --nocapture && \
cd /app/src/tracing && cargo test --test event -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
