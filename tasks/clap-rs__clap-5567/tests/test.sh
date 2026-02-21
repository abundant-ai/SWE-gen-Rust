#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/bash/.inputrc" "clap_complete/tests/snapshots/home/static/exhaustive/bash/.inputrc"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/zsh"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/zsh/.zshenv" "clap_complete/tests/snapshots/home/static/exhaustive/zsh/.zshenv"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/common.rs" "clap_complete/tests/testsuite/common.rs"
cp "/tests/clap_complete/tests/testsuite/dynamic.rs" "clap_complete/tests/testsuite/dynamic.rs"
cp "/tests/clap_complete/tests/testsuite/elvish.rs" "clap_complete/tests/testsuite/elvish.rs"
cp "/tests/clap_complete/tests/testsuite/fish.rs" "clap_complete/tests/testsuite/fish.rs"
cp "/tests/clap_complete/tests/testsuite/zsh.rs" "clap_complete/tests/testsuite/zsh.rs"

# Run specific test modules from clap_complete testsuite
cargo test -p clap_complete --test testsuite 'dynamic::' -- --nocapture && \
cargo test -p clap_complete --test testsuite 'elvish::' -- --nocapture && \
cargo test -p clap_complete --test testsuite 'fish::' -- --nocapture && \
cargo test -p clap_complete --test testsuite 'zsh::' -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
