#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_edit.rs" "tests/test_edit.rs"

# Clean old test artifacts to avoid cache issues
rm -rf target/debug/test_* target/debug/toml_edit-* 2>/dev/null || true

# Rebuild tests after copying test files
cargo build --workspace --all-targets 2>&1

# Run only the test_inline_table_append test which is the new functionality being added
cargo test --test test_edit test_inline_table_append 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
