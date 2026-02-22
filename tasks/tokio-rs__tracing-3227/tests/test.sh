#!/bin/bash

cd /app/src

mkdir -p "tracing/tests"
cp "/tests/tracing/tests/span.rs" "tracing/tests/span.rs"

cargo test --test span -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
