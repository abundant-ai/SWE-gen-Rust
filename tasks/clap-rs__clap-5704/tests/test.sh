#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/derive_ui.rs" "tests/derive_ui.rs"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/value_parser_unsupported.rs" "tests/derive_ui/value_parser_unsupported.rs"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/value_parser_unsupported.stderr" "tests/derive_ui/value_parser_unsupported.stderr"

# Run the derive_ui test with derive and unstable-derive-ui-tests features
cargo test --test derive_ui --features derive,unstable-derive-ui-tests -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
