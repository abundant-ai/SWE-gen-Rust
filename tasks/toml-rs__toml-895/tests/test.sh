#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_bom.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_bom.txt"
mkdir -p "crates/toml_parse/tests/snapshots"
cp "/tests/crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid.txt" "crates/toml_parse/tests/snapshots/testsuite__parse_document__document_invalid.txt"
mkdir -p "crates/toml_parse/tests/testsuite"
cp "/tests/crates/toml_parse/tests/testsuite/main.rs" "crates/toml_parse/tests/testsuite/main.rs"

# Run specific parse_document tests that are part of this PR
# Using exact test names to avoid running unrelated tests
cargo test -p toml_parse --test testsuite -- \
  parse_document::document_bom \
  parse_document::document_invalid \
  --exact
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
