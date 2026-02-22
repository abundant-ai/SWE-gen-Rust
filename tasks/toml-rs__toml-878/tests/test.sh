#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/general.rs" "crates/toml/tests/serde/general.rs"
mkdir -p "crates/toml_edit/tests/serde"
cp "/tests/crates/toml_edit/tests/serde/general.rs" "crates/toml_edit/tests/serde/general.rs"

# Run serde tests from both toml and toml_edit crates
# These tests cover the serde integration changes in this PR
# Note: toml_edit requires the serde feature to be enabled
cargo test -p toml --test serde -- --nocapture && \
cargo test -p toml_edit --test serde --features serde -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
