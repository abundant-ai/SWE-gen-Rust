#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/enum_flatten.stderr" "tests/derive_ui/enum_flatten.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/external_subcommand_wrong_type.stderr" "tests/derive_ui/external_subcommand_wrong_type.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/multiple_external_subcommand.stderr" "tests/derive_ui/multiple_external_subcommand.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/struct_subcommand.stderr" "tests/derive_ui/struct_subcommand.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/subcommand_opt_opt.stderr" "tests/derive_ui/subcommand_opt_opt.stderr"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/subcommand_opt_vec.stderr" "tests/derive_ui/subcommand_opt_vec.stderr"

# Run the derive_ui test target (which includes tests/derive_ui/*.rs)
cargo test --test derive_ui --features derive,unstable-derive-ui-tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
