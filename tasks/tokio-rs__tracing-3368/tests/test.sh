#!/bin/bash

cd /app/src

mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/ansi_escaping.rs" "tracing-subscriber/tests/ansi_escaping.rs"

cargo test --test ansi_escaping -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
