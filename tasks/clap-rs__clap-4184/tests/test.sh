#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Remove test files that were added by bug.patch but don't exist in HEAD
rm -f tests/derive_ui/opt_opt_nonpositional.rs tests/derive_ui/opt_opt_nonpositional.stderr
rm -f tests/derive_ui/opt_vec_nonpositional.rs tests/derive_ui/opt_vec_nonpositional.stderr
rm -f tests/derive_ui/option_default_value.rs tests/derive_ui/option_default_value.stderr

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/skip_with_other_options.stderr" "tests/derive_ui/skip_with_other_options.stderr"
cp "/tests/derive_ui/subcommand_opt_opt.stderr" "tests/derive_ui/subcommand_opt_opt.stderr"
cp "/tests/derive_ui/subcommand_opt_vec.stderr" "tests/derive_ui/subcommand_opt_vec.stderr"

# Run the derive_ui test which tests the .stderr files (requires derive feature)
cargo test --test derive_ui --features derive -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
