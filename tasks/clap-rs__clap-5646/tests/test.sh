#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish" "clap_complete/tests/snapshots/home/static/exhaustive/fish/fish/completions/exhaustive.fish"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/powershell/powershell"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/powershell/powershell/Microsoft.PowerShell_profile.ps1" "clap_complete/tests/snapshots/home/static/exhaustive/powershell/powershell/Microsoft.PowerShell_profile.ps1"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive" "clap_complete/tests/snapshots/home/static/exhaustive/zsh/zsh/_exhaustive"

# Run the register_completion tests that validate the snapshot files
# These tests generate completion files and compare them against snapshots in tests/snapshots/home/static/exhaustive/
# The PR adds PowerShell support, affecting snapshot files for bash, fish, zsh, and elvish
cargo test --package clap_complete --features unstable-dynamic --test testsuite register_completion -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
