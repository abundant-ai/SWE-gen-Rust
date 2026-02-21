#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/dynamic.rs" "clap_complete/tests/testsuite/dynamic.rs"

# Run only the tests in the dynamic module (like the reference task)
# The shell-specific tests (fish, elvish, zsh) may be flaky due to shell environment issues
cargo test --package clap_complete --features unstable-dynamic --test testsuite 'dynamic::' -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
