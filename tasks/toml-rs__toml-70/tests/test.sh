#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/integer-invalid-binary-char.toml" "tests/fixtures/invalid/integer-invalid-binary-char.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/integer-invalid-hex-char.toml" "tests/fixtures/invalid/integer-invalid-hex-char.toml"
mkdir -p "tests/fixtures/invalid"
cp "/tests/fixtures/invalid/integer-invalid-octal-char.toml" "tests/fixtures/invalid/integer-invalid-octal-char.toml"
mkdir -p "tests"
cp "/tests/test_invalid.rs" "tests/test_invalid.rs"
mkdir -p "src/parser"
cp "/tests/mod.rs" "src/parser/mod.rs"

# Rebuild tests after copying test files
cargo build --workspace --all-targets 2>&1

# Run the specific test files for this PR
# This includes both the integration tests (test_invalid) and unit tests (parser::tests)
cargo test --lib parser::tests 2>&1 && cargo test --test test_invalid 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
