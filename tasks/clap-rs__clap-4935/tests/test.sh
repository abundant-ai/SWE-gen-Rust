#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete_nushell/tests"
cp "/tests/clap_complete_nushell/tests/common.rs" "clap_complete_nushell/tests/common.rs"
mkdir -p "clap_complete_nushell/tests"
cp "/tests/clap_complete_nushell/tests/completion.rs" "clap_complete_nushell/tests/completion.rs"
mkdir -p "clap_complete_nushell/tests"
cp "/tests/clap_complete_nushell/tests/nushell.rs" "clap_complete_nushell/tests/nushell.rs"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/aliases.nu" "clap_complete_nushell/tests/snapshots/aliases.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/basic.nu" "clap_complete_nushell/tests/snapshots/basic.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/feature_sample.nu" "clap_complete_nushell/tests/snapshots/feature_sample.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/quoting.nu" "clap_complete_nushell/tests/snapshots/quoting.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/special_commands.nu" "clap_complete_nushell/tests/snapshots/special_commands.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/sub_subcommands.nu" "clap_complete_nushell/tests/snapshots/sub_subcommands.nu"
mkdir -p "clap_complete_nushell/tests/snapshots"
cp "/tests/clap_complete_nushell/tests/snapshots/value_hint.nu" "clap_complete_nushell/tests/snapshots/value_hint.nu"

# Run tests from the clap_complete_nushell package
output=$(cargo test -p clap_complete_nushell --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
