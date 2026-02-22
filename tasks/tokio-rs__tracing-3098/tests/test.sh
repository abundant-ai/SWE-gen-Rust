#!/bin/bash

cd /app/src

mkdir -p "tracing-mock/tests"
cp "/tests/tracing-mock/tests/event_ancestry.rs" "tracing-mock/tests/event_ancestry.rs"
mkdir -p "tracing-mock/tests"
cp "/tests/tracing-mock/tests/span_ancestry.rs" "tracing-mock/tests/span_ancestry.rs"

cargo test --test event_ancestry --test span_ancestry -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
