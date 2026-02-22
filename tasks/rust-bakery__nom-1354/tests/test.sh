#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/multi"
cp "/tests/src/multi/tests.rs" "src/multi/tests.rs"
mkdir -p "tests"
cp "/tests/arithmetic.rs" "tests/arithmetic.rs"
mkdir -p "tests"
cp "/tests/json.rs" "tests/json.rs"
mkdir -p "tests"
cp "/tests/reborrow_fold.rs" "tests/reborrow_fold.rs"

# Run the specific test files from the PR
# For unit tests in src/multi/tests.rs, we use the module path
# For integration tests in tests/, we use --test flag
cargo test multi::tests -- --nocapture && \
cargo test --test arithmetic -- --nocapture && \
cargo test --test json -- --nocapture && \
cargo test --test reborrow_fold -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
