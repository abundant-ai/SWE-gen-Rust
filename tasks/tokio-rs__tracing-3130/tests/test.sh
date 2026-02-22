#!/bin/bash

cd /app/src

mkdir -p "tracing/tests"
cp "/tests/tracing/tests/event.rs" "tracing/tests/event.rs"

cargo test --test event -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
