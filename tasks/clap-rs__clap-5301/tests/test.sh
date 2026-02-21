#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_mangen/tests/snapshots"
cp "/tests/clap_mangen/tests/snapshots/sub_subcommand_help.roff" "clap_mangen/tests/snapshots/sub_subcommand_help.roff"

# Clean and rebuild tests to pick up the restored snapshot test file
# Run tests for the specific test affected by this PR
cargo clean -p clap_mangen
cargo test -p clap_mangen --test roff --no-fail-fast -- \
    'sub_subcommands_help' \
    --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
