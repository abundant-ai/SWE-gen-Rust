#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/markdown.rs" "tests/testsuite/markdown.rs"
mkdir -p "tests/testsuite/markdown/definition_lists"
cp "/tests/testsuite/markdown/definition_lists/book.toml" "tests/testsuite/markdown/definition_lists/book.toml"
mkdir -p "tests/testsuite/markdown/definition_lists/expected"
cp "/tests/testsuite/markdown/definition_lists/expected/definition_lists.html" "tests/testsuite/markdown/definition_lists/expected/definition_lists.html"
mkdir -p "tests/testsuite/markdown/definition_lists/expected_disabled"
cp "/tests/testsuite/markdown/definition_lists/expected_disabled/definition_lists.html" "tests/testsuite/markdown/definition_lists/expected_disabled/definition_lists.html"
mkdir -p "tests/testsuite/markdown/definition_lists/src"
cp "/tests/testsuite/markdown/definition_lists/src/SUMMARY.md" "tests/testsuite/markdown/definition_lists/src/SUMMARY.md"
mkdir -p "tests/testsuite/markdown/definition_lists/src"
cp "/tests/testsuite/markdown/definition_lists/src/definition_lists.md" "tests/testsuite/markdown/definition_lists/src/definition_lists.md"

# Run the specific test for definition_lists
cargo test --test testsuite definition_lists -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
