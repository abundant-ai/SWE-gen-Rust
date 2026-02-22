#!/bin/bash

cd /app/src

mkdir -p "tracing/tests"
cp "/tests/tracing/tests/macros.rs" "tracing/tests/macros.rs"

cargo test --test macros -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
