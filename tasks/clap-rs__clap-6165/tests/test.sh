#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/help.rs" "tests/builder/help.rs"
mkdir -p "tests/builder"
cp "/tests/builder/multiple_values.rs" "tests/builder/multiple_values.rs"
mkdir -p "tests"
cp "/tests/macros.rs" "tests/macros.rs"

# Run the specific test targets for this PR
cargo test --test builder -- help --nocapture
help_status=$?

cargo test --test builder -- multiple_values --nocapture
multiple_values_status=$?

cargo test --test macros -- --nocapture
macros_status=$?

# All tests must pass
if [ $help_status -eq 0 ] && [ $multiple_values_status -eq 0 ] && [ $macros_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
