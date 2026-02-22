#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/external_subcommand_misuse.stderr" "tests/derive_ui/external_subcommand_misuse.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/skip_flatten.stderr" "tests/derive_ui/skip_flatten.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/skip_subcommand.stderr" "tests/derive_ui/skip_subcommand.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/struct_subcommand.stderr" "tests/derive_ui/struct_subcommand.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/subcommand_and_flatten.stderr" "tests/derive_ui/subcommand_and_flatten.stderr"

# Run the derive_ui test which tests the .stderr files (requires derive feature)
cargo test --test derive_ui --features derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
