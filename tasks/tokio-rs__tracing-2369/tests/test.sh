#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/cached_subscriber_filters_dont_break_other_subscribers.rs" "tracing-subscriber/tests/cached_subscriber_filters_dont_break_other_subscribers.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/main.rs" "tracing-subscriber/tests/env_filter/main.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/per_subscriber.rs" "tracing-subscriber/tests/env_filter/per_subscriber.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/hinted_subscriber_filters_dont_break_other_subscribers.rs" "tracing-subscriber/tests/hinted_subscriber_filters_dont_break_other_subscribers.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/multiple_subscriber_filter_interests_cached.rs" "tracing-subscriber/tests/multiple_subscriber_filter_interests_cached.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/subscriber_filter_interests_are_cached.rs" "tracing-subscriber/tests/subscriber_filter_interests_are_cached.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/filter_scopes.rs" "tracing-subscriber/tests/subscriber_filters/filter_scopes.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/main.rs" "tracing-subscriber/tests/subscriber_filters/main.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/per_event.rs" "tracing-subscriber/tests/subscriber_filters/per_event.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/trees.rs" "tracing-subscriber/tests/subscriber_filters/trees.rs"
mkdir -p "tracing-subscriber/tests/subscriber_filters"
cp "/tests/tracing-subscriber/tests/subscriber_filters/vec.rs" "tracing-subscriber/tests/subscriber_filters/vec.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/unhinted_subscriber_filters_dont_break_other_subscribers.rs" "tracing-subscriber/tests/unhinted_subscriber_filters_dont_break_other_subscribers.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/vec_subscriber_filter_interests_cached.rs" "tracing-subscriber/tests/vec_subscriber_filter_interests_cached.rs"

# Rebuild tests after copying new test files (Rust is compiled)
cargo build --workspace --tests

# Run tests for the specific test files from this PR
cargo test -p tracing-subscriber --test cached_subscriber_filters_dont_break_other_subscribers -- --nocapture && \
cargo test -p tracing-subscriber --test env_filter -- --nocapture && \
cargo test -p tracing-subscriber --test hinted_subscriber_filters_dont_break_other_subscribers -- --nocapture && \
cargo test -p tracing-subscriber --test multiple_subscriber_filter_interests_cached -- --nocapture && \
cargo test -p tracing-subscriber --test subscriber_filter_interests_are_cached -- --nocapture && \
cargo test -p tracing-subscriber --test subscriber_filters -- --nocapture && \
cargo test -p tracing-subscriber --test unhinted_subscriber_filters_dont_break_other_subscribers -- --nocapture && \
cargo test -p tracing-subscriber --test vec_subscriber_filter_interests_cached -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
