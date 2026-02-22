#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_edit.rs" "tests/test_edit.rs"
mkdir -p "tests"
cp "/tests/test_invalid.rs" "tests/test_invalid.rs"
mkdir -p "tests"
cp "/tests/test_safety.rs" "tests/test_safety.rs"
mkdir -p "tests"
cp "/tests/test_valid.rs" "tests/test_valid.rs"

# Clean old test artifacts to avoid cache issues
rm -rf target/debug/test_* target/debug/toml_edit-* 2>/dev/null || true

# Rebuild tests after copying test files - this verifies tests compile with FromStr
# The key validation is that the code compiles successfully with .parse::<Document>()
# which requires the FromStr trait implementation
cargo build --workspace --all-targets 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
