#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive"
cp "/tests/derive/main.rs" "tests/derive/main.rs"
mkdir -p "tests/derive"
cp "/tests/derive/occurrences.rs" "tests/derive/occurrences.rs"

# Run the derive integration tests
# The tests are in tests/derive/ which is a single test target called 'derive'
# We test the entire derive target since the touched files are modules within it
# The tests require the derive, help, usage, unstable-grouped, and unstable-v5 features
cargo test --test derive --features derive,help,usage,unstable-grouped,unstable-v5 --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
