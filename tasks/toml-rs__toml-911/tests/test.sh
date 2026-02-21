#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__array_and_inline_table_outside_recursion_limit.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__array_and_inline_table_outside_recursion_limit.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__array_outside_recursion_limit.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__array_outside_recursion_limit.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_key_dot_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_missing_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_inline_table_missing_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_comment.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_comment.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_cr.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_cr.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_dot_dot_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_missing_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_missing_key.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot_dot.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot_dot.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot_dot_key.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_table_dot_dot_key.txt"

# Run specific parse_document tests that are part of this PR
# Using exact test names to avoid running unrelated tests
cargo test -p toml_parse --test testsuite -- \
  parse_document::document_dot \
  parse_document::document_dot_dot \
  parse_document::document_dot_key \
  parse_document::document_dot_dot_key \
  parse_document::document_key_dot \
  parse_document::document_key_dot_dot \
  parse_document::document_key_dot_dot_key \
  parse_document::document_inline_table_dot \
  parse_document::document_inline_table_dot_dot \
  parse_document::document_inline_table_dot_key \
  parse_document::document_inline_table_dot_dot_key \
  parse_document::document_inline_table_key_dot \
  parse_document::document_inline_table_key_dot_dot \
  parse_document::document_inline_table_key_dot_dot_key \
  parse_document::document_inline_table_missing_key \
  parse_document::document_missing_key \
  parse_document::document_invalid_comment \
  parse_document::document_invalid_cr \
  parse_document::array_outside_recursion_limit \
  parse_document::array_and_inline_table_outside_recursion_limit \
  parse_document::document_table_dot \
  parse_document::document_table_dot_dot \
  parse_document::document_table_dot_dot_key \
  --exact
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
