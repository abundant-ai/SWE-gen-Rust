#!/bin/bash

cd /app/src

# Try to compile the testsuite - it will fail if testsuite doesn't exist
cargo test --test testsuite --no-run
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
