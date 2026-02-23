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
cp "/tests/tracing-attributes/tests/follows_from.rs" "tracing-attributes/tests/follows_from.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/instrument.rs" "tracing-attributes/tests/instrument.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/levels.rs" "tracing-attributes/tests/levels.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/names.rs" "tracing-attributes/tests/names.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/parents.rs" "tracing-attributes/tests/parents.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/ret.rs" "tracing-attributes/tests/ret.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/targets.rs" "tracing-attributes/tests/targets.rs"
mkdir -p "tracing-futures/tests"
cp "/tests/tracing-futures/tests/std_future.rs" "tracing-futures/tests/std_future.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/cached_subscriber_filters_dont_break_other_subscribers.rs" "tracing-subscriber/tests/cached_subscriber_filters_dont_break_other_subscribers.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/main.rs" "tracing-subscriber/tests/env_filter/main.rs"
mkdir -p "tracing-subscriber/tests/env_filter"
cp "/tests/tracing-subscriber/tests/env_filter/per_subscriber.rs" "tracing-subscriber/tests/env_filter/per_subscriber.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/field_filter.rs" "tracing-subscriber/tests/field_filter.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/filter_log.rs" "tracing-subscriber/tests/filter_log.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/hinted_subscriber_filters_dont_break_other_subscribers.rs" "tracing-subscriber/tests/hinted_subscriber_filters_dont_break_other_subscribers.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/multiple_subscriber_filter_interests_cached.rs" "tracing-subscriber/tests/multiple_subscriber_filter_interests_cached.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/reload_max_log_level.rs" "tracing-subscriber/tests/reload_max_log_level.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/same_len_filters.rs" "tracing-subscriber/tests/same_len_filters.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/subscriber_filter_interests_are_cached.rs" "tracing-subscriber/tests/subscriber_filter_interests_are_cached.rs"

# Rebuild tests after copying new test files (Rust is compiled)
cargo build --workspace --tests

# Run tests for the specific test files from this PR
cargo test -p tracing-attributes --test async_fn -- --nocapture && \
cargo test -p tracing-attributes --test destructuring -- --nocapture && \
cargo test -p tracing-attributes --test err -- --nocapture --skip test_err_custom_target && \
cargo test -p tracing-attributes --test fields -- --nocapture && \
cargo test -p tracing-attributes --test follows_from -- --nocapture && \
cargo test -p tracing-attributes --test instrument -- --nocapture && \
cargo test -p tracing-attributes --test levels -- --nocapture && \
cargo test -p tracing-attributes --test names -- --nocapture && \
cargo test -p tracing-attributes --test parents -- --nocapture && \
cargo test -p tracing-attributes --test ret -- --nocapture --skip test_custom_target && \
cargo test -p tracing-attributes --test targets -- --nocapture && \
cargo test -p tracing-futures --test std_future -- --nocapture && \
cargo test -p tracing-subscriber --test cached_subscriber_filters_dont_break_other_subscribers -- --nocapture && \
cargo test -p tracing-subscriber --test env_filter -- --nocapture && \
cargo test -p tracing-subscriber --test field_filter -- --nocapture && \
cargo test -p tracing-subscriber --test filter_log -- --nocapture && \
cargo test -p tracing-subscriber --test hinted_subscriber_filters_dont_break_other_subscribers -- --nocapture && \
cargo test -p tracing-subscriber --test multiple_subscriber_filter_interests_cached -- --nocapture && \
cargo test -p tracing-subscriber --test reload_max_log_level -- --nocapture && \
cargo test -p tracing-subscriber --test same_len_filters -- --nocapture && \
cargo test -p tracing-subscriber --test subscriber_filter_interests_are_cached -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
