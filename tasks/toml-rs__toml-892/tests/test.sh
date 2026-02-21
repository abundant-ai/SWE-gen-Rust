#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_complex.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_complex.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_comment.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_comment.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_cr.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid_cr.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_string_comment.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_string_comment.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_ws.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_key_ws.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_ws.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_ws.txt"
mkdir -p "crates/toml_parse/tests/testsuite"
cp "/tests/crates/toml_parse/tests/testsuite/parse_document.rs" "crates/toml_parse/tests/testsuite/parse_document.rs"

# Run specific parse_document tests that are part of this PR
# Using exact test names to avoid running unrelated tests
cargo test -p toml_parse --test testsuite -- \
  parse_document::document_complex \
  parse_document::document_invalid \
  parse_document::document_invalid_comment \
  parse_document::document_invalid_cr \
  parse_document::document_key_string_comment \
  parse_document::document_key_ws \
  parse_document::document_ws \
  --exact
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
