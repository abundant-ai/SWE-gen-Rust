#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-core/tests"
cp "/tests/tracing-core/tests/local_dispatch_before_init.rs" "tracing-core/tests/local_dispatch_before_init.rs"

cargo test --test local_dispatch_before_init -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
