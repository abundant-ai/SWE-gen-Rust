#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/main.rs" "tracing-subscriber/tests/subscriber_filters/main.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/per_event.rs" "tracing-subscriber/tests/subscriber_filters/per_event.rs"

cargo build -p tracing-subscriber --tests
cargo test -p tracing-subscriber --test subscriber_filters -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
