#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/dynamic-command/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/register_minimal.bash" "clap_complete/tests/snapshots/register_minimal.bash"

# Run the specific tests that use these snapshot files
# Tests are in bash.rs and zsh.rs that use the dynamic-command, dynamic-env, and register_minimal snapshots
# Run register_minimal test first
cargo test --package clap_complete --features unstable-dynamic,unstable-command register_minimal -- --nocapture
test_status1=$?

# Run register_dynamic tests (matches both register_dynamic_command and register_dynamic_env)
cargo test --package clap_complete --features unstable-dynamic,unstable-command register_dynamic -- --nocapture
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
