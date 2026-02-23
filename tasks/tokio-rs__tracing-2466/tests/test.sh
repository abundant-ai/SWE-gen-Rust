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
mkdir -p "tracing/test_static_max_level_features/tests"
cp "/tests/tracing/test_static_max_level_features/tests/test.rs" "tracing/test_static_max_level_features/tests/test.rs"

# Run tests for the specific test files from this PR
cd /app/src/tracing-attributes && cargo test --test async_fn -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test err -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test follows_from -- --nocapture && \
cd /app/src/tracing-attributes && cargo test --test ret -- --nocapture && \
cd /app/src/tracing-futures && cargo test --test std_future -- --nocapture && \
cd /app/src/tracing/test_static_max_level_features && cargo test --test test -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
