#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/action.rs" "tests/builder/action.rs"
mkdir -p "tests/builder"
cp "/tests/builder/flags.rs" "tests/builder/flags.rs"
mkdir -p "tests/derive"
cp "/tests/derive/flags.rs" "tests/derive/flags.rs"

# Run specific tests from the modified test files
# Tests are in: tests/builder/action.rs, tests/builder/flags.rs, tests/derive/flags.rs
# The 'builder' and 'derive' are test targets that include these files
cargo test --test builder --test derive --features help,usage,error-context,derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
