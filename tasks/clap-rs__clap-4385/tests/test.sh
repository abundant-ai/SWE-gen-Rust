#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/empty_values.rs" "tests/builder/empty_values.rs"
mkdir -p "tests/builder"
cp "/tests/builder/error.rs" "tests/builder/error.rs"
mkdir -p "tests/builder"
cp "/tests/builder/flags.rs" "tests/builder/flags.rs"
mkdir -p "tests/builder"
cp "/tests/builder/opts.rs" "tests/builder/opts.rs"
mkdir -p "tests/builder"
cp "/tests/builder/possible_values.rs" "tests/builder/possible_values.rs"
mkdir -p "tests/builder"
cp "/tests/builder/subcommands.rs" "tests/builder/subcommands.rs"

# Run the builder integration tests
# The test files are in tests/builder/ which is part of the 'builder' test target
cargo test --test builder --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
