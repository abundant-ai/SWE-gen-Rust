#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/bash.rs" "clap_complete/tests/bash.rs"
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/common.rs" "clap_complete/tests/common.rs"
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/elvish.rs" "clap_complete/tests/elvish.rs"
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/fish.rs" "clap_complete/tests/fish.rs"
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/powershell.rs" "clap_complete/tests/powershell.rs"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.bash" "clap_complete/tests/snapshots/value_terminator.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.elvish" "clap_complete/tests/snapshots/value_terminator.elvish"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.fish" "clap_complete/tests/snapshots/value_terminator.fish"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.ps1" "clap_complete/tests/snapshots/value_terminator.ps1"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.zsh" "clap_complete/tests/snapshots/value_terminator.zsh"
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/zsh.rs" "clap_complete/tests/zsh.rs"

# Run the specific integration tests from clap_complete
# The test files are in clap_complete/tests/, which are integration tests for the clap_complete crate
# We need to run the tests for bash, elvish, fish, powershell, and zsh completion shells

cargo test --package clap_complete --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
