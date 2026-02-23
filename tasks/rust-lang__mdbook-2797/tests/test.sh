#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-driver/src/mdbook"
cp "/tests/crates/mdbook-driver/src/mdbook/tests.rs" "crates/mdbook-driver/src/mdbook/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/preprocessor.rs" "tests/testsuite/preprocessor.rs"
mkdir -p "tests/testsuite/preprocessor/missing_optional_not_fatal"
cp "/tests/testsuite/preprocessor/missing_optional_not_fatal/book.toml" "tests/testsuite/preprocessor/missing_optional_not_fatal/book.toml"
mkdir -p "tests/testsuite/preprocessor/missing_optional_not_fatal/src"
cp "/tests/testsuite/preprocessor/missing_optional_not_fatal/src/SUMMARY.md" "tests/testsuite/preprocessor/missing_optional_not_fatal/src/SUMMARY.md"
mkdir -p "tests/testsuite/preprocessor/missing_preprocessor"
cp "/tests/testsuite/preprocessor/missing_preprocessor/book.toml" "tests/testsuite/preprocessor/missing_preprocessor/book.toml"
mkdir -p "tests/testsuite/preprocessor/missing_preprocessor/src"
cp "/tests/testsuite/preprocessor/missing_preprocessor/src/SUMMARY.md" "tests/testsuite/preprocessor/missing_preprocessor/src/SUMMARY.md"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/renderer.rs" "tests/testsuite/renderer.rs"

# Run only the specific tests that were modified/added in the PR
# The PR modified: missing_preprocessor and added missing_optional_not_fatal
# Use a pattern to match both tests
cargo test --test testsuite missing_ -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
