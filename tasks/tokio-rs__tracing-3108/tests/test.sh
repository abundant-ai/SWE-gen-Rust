#!/bin/bash

cd /app/src

mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/async_fn.rs" "tracing-attributes/tests/async_fn.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/dead_code.rs" "tracing-attributes/tests/dead_code.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/err.rs" "tracing-attributes/tests/err.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/instrument.rs" "tracing-attributes/tests/instrument.rs"
mkdir -p "tracing-attributes/tests/ui"
cp "/tests/tracing-attributes/tests/ui/async_instrument.rs" "tracing-attributes/tests/ui/async_instrument.rs"
mkdir -p "tracing-attributes/tests/ui"
cp "/tests/tracing-attributes/tests/ui/async_instrument.stderr" "tracing-attributes/tests/ui/async_instrument.stderr"

cargo test --test async_fn --test dead_code --test err --test instrument -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
