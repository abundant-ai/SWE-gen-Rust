#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/highlight_test.rs" "crates/cli/src/tests/highlight_test.rs"

# Run the specific tests from the highlight_test module (cargo test will rebuild as needed)
cargo test --package tree-sitter-cli --lib tests::highlight_test -- --nocapture --show-output 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
