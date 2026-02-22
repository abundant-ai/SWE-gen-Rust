#!/bin/bash

cd /app/src

mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/parents.rs" "tracing-attributes/tests/parents.rs"
mkdir -p "tracing-futures/tests"
cp "/tests/tracing-futures/tests/std_future.rs" "tracing-futures/tests/std_future.rs"
mkdir -p "tracing-mock/tests"
cp "/tests/tracing-mock/tests/event_ancestry.rs" "tracing-mock/tests/event_ancestry.rs"
mkdir -p "tracing-mock/tests"
cp "/tests/tracing-mock/tests/span_ancestry.rs" "tracing-mock/tests/span_ancestry.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/event.rs" "tracing/tests/event.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/instrument.rs" "tracing/tests/instrument.rs"
mkdir -p "tracing/tests"
cp "/tests/tracing/tests/span.rs" "tracing/tests/span.rs"

cargo test --test parents --test std_future --test event_ancestry --test span_ancestry --test event --test instrument --test span -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
