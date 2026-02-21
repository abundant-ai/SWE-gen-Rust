#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive"
cp "/tests/derive/help.rs" "tests/derive/help.rs"

# Run the specific test targets for this PR
# Tests in tests/derive/help.rs - requires derive, help, and usage features
cargo test --features derive,help,usage --test derive -- help --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
