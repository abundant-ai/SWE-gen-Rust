#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-in-flight-limit/tests"
cp "/tests/tower-in-flight-limit/tests/in_flight_limit.rs" "tower-in-flight-limit/tests/in_flight_limit.rs"
mkdir -p "tower-mock/tests"
cp "/tests/tower-mock/tests/mock.rs" "tower-mock/tests/mock.rs"
mkdir -p "tower-rate-limit/tests"
cp "/tests/tower-rate-limit/tests/rate_limit.rs" "tower-rate-limit/tests/rate_limit.rs"

# Run tests to validate that poll_ready enforcement works correctly
cargo test --test in_flight_limit --manifest-path tower-in-flight-limit/Cargo.toml && \
cargo test --test mock --manifest-path tower-mock/Cargo.toml && \
cargo test --test rate_limit --manifest-path tower-rate-limit/Cargo.toml
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
