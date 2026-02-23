#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/option_filter_interest_caching.rs" "tracing-subscriber/tests/option_filter_interest_caching.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/main.rs" "tracing-subscriber/tests/subscriber_filters/main.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/option.rs" "tracing-subscriber/tests/subscriber_filters/option.rs"

# Run tests for the specific test files from this PR
cd /app/src/tracing-subscriber && cargo test --test option_filter_interest_caching -- --nocapture && \
cd /app/src/tracing-subscriber && cargo test --test subscriber_filters -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
