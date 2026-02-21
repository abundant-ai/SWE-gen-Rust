#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/de_key.rs" "crates/toml/tests/serde/de_key.rs"
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/main.rs" "crates/toml/tests/serde/main.rs"
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/ser_key.rs" "crates/toml/tests/serde/ser_key.rs"
mkdir -p "crates/toml_edit/tests/serde"
cp "/tests/crates/toml_edit/tests/serde/de_key.rs" "crates/toml_edit/tests/serde/de_key.rs"
mkdir -p "crates/toml_edit/tests/serde"
cp "/tests/crates/toml_edit/tests/serde/main.rs" "crates/toml_edit/tests/serde/main.rs"
mkdir -p "crates/toml_edit/tests/serde"
cp "/tests/crates/toml_edit/tests/serde/ser_key.rs" "crates/toml_edit/tests/serde/ser_key.rs"

# Run tests for the serde module in both toml and toml_edit crates
# These tests cover the key serialization/deserialization changes in this PR
# Note: toml_edit requires features to be enabled for the serde test
cargo test -p toml --test serde && \
cargo test -p toml_edit --test serde --features parse,display,serde
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
