#!/bin/bash

cd /app/src

mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/instrument.rs" "tracing-attributes/tests/instrument.rs"

cargo test --test instrument -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
