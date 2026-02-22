#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/display.rs" "crates/toml/tests/testsuite/display.rs"
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/edit.rs" "crates/toml_edit/tests/testsuite/edit.rs"

# Run tests for both toml and toml_edit packages
cargo test -p toml --test testsuite -- --nocapture && \
cargo test -p toml_edit --test testsuite -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
