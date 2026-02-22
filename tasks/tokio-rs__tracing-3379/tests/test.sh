#!/bin/bash

cd /app/src

mkdir -p "tracing-mock/tests"
cp "/tests/tracing-mock/tests/on_register_dispatch.rs" "tracing-mock/tests/on_register_dispatch.rs"
mkdir -p "tracing-subscriber/tests"
cp "/tests/tracing-subscriber/tests/on_register_dispatch_is_called.rs" "tracing-subscriber/tests/on_register_dispatch_is_called.rs"

cargo test --test on_register_dispatch -- --nocapture && \
cargo test --test on_register_dispatch_is_called -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
