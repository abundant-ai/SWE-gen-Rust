#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-core/tests"
cp "/tests/tracing-core/tests/macros.rs" "tracing-core/tests/macros.rs"

cargo build -p tracing-core --tests
cargo test -p tracing-core --test macros -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
