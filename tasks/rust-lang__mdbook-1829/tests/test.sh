#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/dummy_book/index_html_test"
cp "/tests/dummy_book/index_html_test/SUMMARY.md" "tests/dummy_book/index_html_test/SUMMARY.md"
mkdir -p "tests/dummy_book/index_html_test"
cp "/tests/dummy_book/index_html_test/chapter_1.md" "tests/dummy_book/index_html_test/chapter_1.md"
mkdir -p "tests"
cp "/tests/rendered_output.rs" "tests/rendered_output.rs"

# Run the specific test from the PR
cargo test --test rendered_output first_chapter_is_copied_as_index_even_if_not_first_elem -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
