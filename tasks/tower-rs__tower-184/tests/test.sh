#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-in-flight-limit/tests"
cp "/tests/tower-in-flight-limit/tests/in_flight_limit.rs" "tower-in-flight-limit/tests/in_flight_limit.rs"

# Run specific test that verifies the in-flight-limit fix
# This test verifies proper capacity management when services with shared state are dropped
cargo test --test in_flight_limit --manifest-path tower-in-flight-limit/Cargo.toml service_drop_frees_capacity
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
