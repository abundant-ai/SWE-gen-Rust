#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/main.rs" "tests/builder/main.rs"
mkdir -p "tests/builder"
cp "/tests/builder/occurrences.rs" "tests/builder/occurrences.rs"

# Run the builder integration tests
# The tests are in tests/builder/ which is a single test target called 'builder'
# We test the entire builder target since the touched files are modules within it
# The tests require the help, usage, and unstable-grouped features
cargo test --test builder --features help,usage,unstable-grouped --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
