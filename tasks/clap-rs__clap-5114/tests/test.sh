#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/elvish/elvish"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/elvish/elvish/rc.elv" "clap_complete/tests/snapshots/home/static/exhaustive/elvish/elvish/rc.elv"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish" "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.fish" "clap_complete/tests/snapshots/sub_subcommands.fish"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_hint.fish" "clap_complete/tests/snapshots/value_hint.fish"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/fish.rs" "clap_complete/tests/testsuite/fish.rs"

# Run the specific tests from the fish module in clap_complete
output=$(cargo test -p clap_complete fish --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
