#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-driver/src/mdbook"
cp "/tests/crates/mdbook-driver/src/mdbook/tests.rs" "crates/mdbook-driver/src/mdbook/tests.rs"

# Run the specific tests from the mdbook module in mdbook-driver crate
cargo test -p mdbook-driver --lib mdbook::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
