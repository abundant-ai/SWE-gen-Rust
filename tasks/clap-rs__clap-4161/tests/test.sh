#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/flags.rs" "tests/builder/flags.rs"
mkdir -p "tests/builder"
cp "/tests/builder/opts.rs" "tests/builder/opts.rs"
mkdir -p "tests/builder"
cp "/tests/builder/possible_values.rs" "tests/builder/possible_values.rs"
mkdir -p "tests/builder"
cp "/tests/builder/subcommands.rs" "tests/builder/subcommands.rs"
mkdir -p "tests/builder"
cp "/tests/builder/utils.rs" "tests/builder/utils.rs"
mkdir -p "tests/derive"
cp "/tests/derive/utils.rs" "tests/derive/utils.rs"
mkdir -p "tests/ui"
cp "/tests/ui/error_stderr.toml" "tests/ui/error_stderr.toml"

# Run tests for the specific files modified in this PR
# Tests are in: tests/builder/*.rs, tests/derive/utils.rs, and tests/ui/error_stderr.toml
cargo test --test builder --test derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
