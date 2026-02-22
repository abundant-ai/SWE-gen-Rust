#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/help.rs" "tests/builder/help.rs"
mkdir -p "tests/builder"
cp "/tests/builder/multiple_values.rs" "tests/builder/multiple_values.rs"
mkdir -p "tests/builder"
cp "/tests/builder/positionals.rs" "tests/builder/positionals.rs"
mkdir -p "tests/builder"
cp "/tests/builder/subcommands.rs" "tests/builder/subcommands.rs"
mkdir -p "tests/derive"
cp "/tests/derive/app_name.rs" "tests/derive/app_name.rs"
mkdir -p "tests/derive"
cp "/tests/derive/arguments.rs" "tests/derive/arguments.rs"
mkdir -p "tests/derive"
cp "/tests/derive/help.rs" "tests/derive/help.rs"
mkdir -p "tests/derive"
cp "/tests/derive/utils.rs" "tests/derive/utils.rs"

# Run the specific test modules for this PR
# The modified test files are in tests/builder/ and tests/derive/ directories
# These are organized as modules within the 'builder' and 'derive' integration tests

# Run all builder tests (includes help, multiple_values, positionals, subcommands modules)
cargo test --test builder -- --nocapture
test_status=$?

# Run all derive tests (includes app_name, arguments, help, utils modules)
if [ $test_status -eq 0 ]; then
  cargo test --test derive -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
