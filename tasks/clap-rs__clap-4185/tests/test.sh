#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/builder"
cp "/tests/src/builder/tests.rs" "src/builder/tests.rs"

# Run the specific test module for this PR (tests in src/builder/tests.rs)
cargo test --lib builder::tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
