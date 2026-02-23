#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/markdown.rs" "tests/testsuite/markdown.rs"
mkdir -p "tests/testsuite/markdown/admonitions"
cp "/tests/testsuite/markdown/admonitions/book.toml" "tests/testsuite/markdown/admonitions/book.toml"
mkdir -p "tests/testsuite/markdown/admonitions/expected"
cp "/tests/testsuite/markdown/admonitions/expected/admonitions.html" "tests/testsuite/markdown/admonitions/expected/admonitions.html"
mkdir -p "tests/testsuite/markdown/admonitions/expected_disabled"
cp "/tests/testsuite/markdown/admonitions/expected_disabled/admonitions.html" "tests/testsuite/markdown/admonitions/expected_disabled/admonitions.html"
mkdir -p "tests/testsuite/markdown/admonitions/src"
cp "/tests/testsuite/markdown/admonitions/src/SUMMARY.md" "tests/testsuite/markdown/admonitions/src/SUMMARY.md"
mkdir -p "tests/testsuite/markdown/admonitions/src"
cp "/tests/testsuite/markdown/admonitions/src/admonitions.md" "tests/testsuite/markdown/admonitions/src/admonitions.md"

# Run the specific test: admonitions test from markdown.rs
cargo test --test testsuite admonitions -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
