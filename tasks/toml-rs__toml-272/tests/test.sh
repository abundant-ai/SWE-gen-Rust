#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_invalid.rs" "tests/test_invalid.rs"

# Copy HEAD source files containing tests
cp "/tests/mod.rs" "src/parser/mod.rs"

# Run the specific tests from the PR
# The main regression test is parser::tests::documents which tests that "foo = 1979-05-27 # Comment" parses
cargo test --lib parser::tests::documents -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
