#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-buffer/tests"
cp "/tests/tower-buffer/tests/buffer.rs" "tower-buffer/tests/buffer.rs"
mkdir -p "tower-filter/tests"
cp "/tests/tower-filter/tests/filter.rs" "tower-filter/tests/filter.rs"
mkdir -p "tower-in-flight-limit/tests"
cp "/tests/tower-in-flight-limit/tests/in_flight_limit.rs" "tower-in-flight-limit/tests/in_flight_limit.rs"
mkdir -p "tower-mock/tests"
cp "/tests/tower-mock/tests/mock.rs" "tower-mock/tests/mock.rs"
mkdir -p "tower-rate-limit/tests"
cp "/tests/tower-rate-limit/tests/rate_limit.rs" "tower-rate-limit/tests/rate_limit.rs"
mkdir -p "tower-retry/tests"
cp "/tests/tower-retry/tests/retry.rs" "tower-retry/tests/retry.rs"

# Build tests to validate that the type signatures are correct
# We cannot run the tests due to futures 0.1 Task panics on Rust 1.70,
# but successful compilation proves the API changes (Mock<T, U> instead of Mock<T, U, E>)
cargo test --test buffer --manifest-path tower-buffer/Cargo.toml --no-run && \
cargo test --test filter --manifest-path tower-filter/Cargo.toml --no-run && \
cargo test --test in_flight_limit --manifest-path tower-in-flight-limit/Cargo.toml --no-run && \
cargo test --test mock --manifest-path tower-mock/Cargo.toml --no-run && \
cargo test --test rate_limit --manifest-path tower-rate-limit/Cargo.toml --no-run && \
cargo test --test retry --manifest-path tower-retry/Cargo.toml --no-run
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
