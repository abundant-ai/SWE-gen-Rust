#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/elvish/elvish"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/elvish/elvish/rc.elv" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/elvish/elvish/rc.elv"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish/completions/exhaustive.fish" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish/completions/exhaustive.fish"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish/config.fish" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/fish/fish/config.fish"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/.zshenv" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/.zshenv"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/elvish/elvish"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/elvish/elvish/rc.elv" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/elvish/elvish/rc.elv"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish/completions/exhaustive.fish" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish/completions/exhaustive.fish"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish/config.fish" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/fish/fish/config.fish"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/.zshenv" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/.zshenv"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/bash.rs" "clap_complete/tests/testsuite/bash.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/common.rs" "clap_complete/tests/testsuite/common.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/elvish.rs" "clap_complete/tests/testsuite/elvish.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/fish.rs" "clap_complete/tests/testsuite/fish.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/zsh.rs" "clap_complete/tests/testsuite/zsh.rs"

# Run the register tests for dynamic-command and dynamic-env snapshots
# Only run register tests, not complete tests (which are runtime PTY tests that can be flaky)
cargo test --package clap_complete --features unstable-dynamic,unstable-command --test testsuite register_dynamic_env -- --nocapture
test_status1=$?

cargo test --package clap_complete --features unstable-dynamic,unstable-command --test testsuite register_dynamic_command -- --nocapture
test_status2=$?

# Combine exit codes - if any test fails, overall status is failure
if [ $test_status1 -eq 0 ] && [ $test_status2 -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
