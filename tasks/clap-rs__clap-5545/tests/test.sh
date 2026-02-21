#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh/.zshenv" "clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh/.zshenv"
mkdir -p "clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/dynamic/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish" "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/zsh.rs" "clap_complete/tests/testsuite/zsh.rs"

# Run specific test module from clap_complete testsuite (zsh tests)
cargo test -p clap_complete --test testsuite 'zsh::' -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
