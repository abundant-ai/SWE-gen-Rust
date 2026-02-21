#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder_compliance.rs" "crates/toml/tests/decoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_compliance.rs" "crates/toml/tests/encoder_compliance.rs"
mkdir -p "crates/toml/tests/fixtures/valid/ext/table"
cp "/tests/crates/toml/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.json" "crates/toml/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.json"
mkdir -p "crates/toml/tests/fixtures/valid/ext/table"
cp "/tests/crates/toml/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.toml" "crates/toml/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.toml"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/decoder_compliance.rs" "crates/toml_edit/tests/decoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/encoder_compliance.rs" "crates/toml_edit/tests/encoder_compliance.rs"
mkdir -p "crates/toml_edit/tests/fixtures/valid/ext/table"
cp "/tests/crates/toml_edit/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.json" "crates/toml_edit/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.json"
mkdir -p "crates/toml_edit/tests/fixtures/valid/ext/table"
cp "/tests/crates/toml_edit/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.toml" "crates/toml_edit/tests/fixtures/valid/ext/table/append-with-dotted-keys-1.toml"

# Run the specific integration tests from the PR
# These tests use a custom test harness, so no -- --nocapture flag
cargo test --test decoder_compliance --test encoder_compliance -p toml && \
cargo test --test decoder_compliance --test encoder_compliance -p toml_edit
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
