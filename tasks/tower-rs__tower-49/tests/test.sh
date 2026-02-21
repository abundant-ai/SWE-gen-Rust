#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-in-flight-limit/tests"
cp "/tests/tower-in-flight-limit/tests/in_flight_limit.rs" "tower-in-flight-limit/tests/in_flight_limit.rs"

# Run tests to validate the in-flight-limit implementation
cargo test -p tower-in-flight-limit --test in_flight_limit
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
