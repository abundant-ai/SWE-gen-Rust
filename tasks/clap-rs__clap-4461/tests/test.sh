#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive"
cp "/tests/derive/doc_comments_help.rs" "tests/derive/doc_comments_help.rs"

# Run the derive integration tests
# The tests are in tests/derive/ which is a single test target called 'derive'
# We test the entire derive target since the touched files are modules within it
# The tests require the derive, help, and usage features
cargo test --test derive --features derive,help,usage --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
