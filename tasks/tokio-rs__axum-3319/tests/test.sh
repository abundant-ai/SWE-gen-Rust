#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum/tests"
cp "/tests/axum/tests/panic_location.rs" "axum/tests/panic_location.rs"

# Run the specific test file for panic_location
cd /app/src/axum
cargo test --test panic_location -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
