#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/spanned.rs" "crates/toml/tests/serde/spanned.rs"
mkdir -p "crates/toml_edit/tests/serde"
cp "/tests/crates/toml_edit/tests/serde/spanned.rs" "crates/toml_edit/tests/serde/spanned.rs"

# Run tests for the specific test files
# Test files: crates/toml/tests/serde/spanned.rs and crates/toml_edit/tests/serde/spanned.rs
# These tests are in the "serde" test target for both crates
cargo test -p toml --features "parse,display" --test serde && cargo test -p toml_edit --features "serde" --test serde
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
