#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Remove BASE test file and copy HEAD test files from /tests
# In BASE state, the test file is named dynamic.rs (bug.patch renames engine.rs to dynamic.rs)
# We need to remove it and copy the HEAD version as engine.rs
rm -f "clap_complete/tests/testsuite/dynamic.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/engine.rs" "clap_complete/tests/testsuite/engine.rs"

# Run the engine tests from clap_complete (tests in clap_complete/tests/testsuite/engine.rs)
# These tests require the unstable-dynamic feature
cargo test --package clap_complete --features unstable-dynamic engine -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
