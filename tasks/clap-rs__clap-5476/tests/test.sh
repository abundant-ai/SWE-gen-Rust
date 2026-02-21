#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/quoting.zsh" "clap_complete/tests/snapshots/quoting.zsh"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/special_commands.zsh" "clap_complete/tests/snapshots/special_commands.zsh"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.bash" "clap_complete/tests/snapshots/sub_subcommands.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.elvish" "clap_complete/tests/snapshots/sub_subcommands.elvish"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.fish" "clap_complete/tests/snapshots/sub_subcommands.fish"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.ps1" "clap_complete/tests/snapshots/sub_subcommands.ps1"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.zsh" "clap_complete/tests/snapshots/sub_subcommands.zsh"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/subcommand_last.zsh" "clap_complete/tests/snapshots/subcommand_last.zsh"

# Clean and rebuild tests to pick up the restored snapshot test files
# Run tests for the specific shell completions affected by this PR
# These tests verify that visible_alias is correctly handled in completion generation
cargo clean -p clap_complete
cargo test -p clap_complete --test testsuite --no-fail-fast -- \
    'zsh::quoting' \
    'zsh::special_commands' \
    'zsh::sub_subcommands' \
    'zsh::subcommand_last' \
    'bash::sub_subcommands' \
    'elvish::sub_subcommands' \
    'fish::sub_subcommands' \
    'powershell::sub_subcommands' \
    --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
