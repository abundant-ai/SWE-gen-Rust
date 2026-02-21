#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
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

# Run the tests that were modified by this PR
# The PR changes feature gates from unstable-dynamic to unstable-command for certain tests
# Run only the register_minimal test which was changed
cargo test --package clap_complete --features unstable-dynamic,unstable-command --test testsuite register_minimal -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
