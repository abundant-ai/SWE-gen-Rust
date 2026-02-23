#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/async_fn.rs" "tracing-attributes/tests/async_fn.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/err.rs" "tracing-attributes/tests/err.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/follows_from.rs" "tracing-attributes/tests/follows_from.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/ret.rs" "tracing-attributes/tests/ret.rs"
mkdir -p "tracing-futures/tests"
cp "/tests/tracing-futures/tests/std_future.rs" "tracing-futures/tests/std_future.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/instrument.rs" "tracing/tests/instrument.rs"

# Run all the async tests that are affected by the instrument Drop behavior
(cargo test --test async_fn -- --nocapture && \
 cargo test --test err test_async -- --nocapture && \
 cargo test --test err test_mut_async -- --nocapture && \
 cargo test --test follows_from follows_from_async_test -- --nocapture && \
 cargo test --test ret test_async -- --nocapture && \
 cargo test --test std_future -- --nocapture && \
 cargo test --test instrument -- --nocapture)
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
