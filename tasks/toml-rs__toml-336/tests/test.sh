#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/README.md" "crates/test-suite/tests/README.md"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/backcompat.rs" "crates/test-suite/tests/backcompat.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/datetime.rs" "crates/test-suite/tests/datetime.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/de-errors.rs" "crates/test-suite/tests/de-errors.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/display-tricky.rs" "crates/test-suite/tests/display-tricky.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/display.rs" "crates/test-suite/tests/display.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/float.rs" "crates/test-suite/tests/float.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/formatting.rs" "crates/test-suite/tests/formatting.rs"
mkdir -p "crates/test-suite/tests/invalid-encoder"
cp "/tests/crates/test-suite/tests/invalid-encoder/array-mixed-types-ints-and-floats.json" "crates/test-suite/tests/invalid-encoder/array-mixed-types-ints-and-floats.json"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/invalid-misc.rs" "crates/test-suite/tests/invalid-misc.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/invalid.rs" "crates/test-suite/tests/invalid.rs"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/datetime-malformed-no-leads.toml" "crates/test-suite/tests/invalid/datetime-malformed-no-leads.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/datetime-malformed-no-secs.toml" "crates/test-suite/tests/invalid/datetime-malformed-no-secs.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/datetime-malformed-no-t.toml" "crates/test-suite/tests/invalid/datetime-malformed-no-t.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/datetime-malformed-with-milli.toml" "crates/test-suite/tests/invalid/datetime-malformed-with-milli.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/duplicate-key-table.toml" "crates/test-suite/tests/invalid/duplicate-key-table.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/duplicate-keys.toml" "crates/test-suite/tests/invalid/duplicate-keys.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/duplicate-table.toml" "crates/test-suite/tests/invalid/duplicate-table.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/duplicate-tables.toml" "crates/test-suite/tests/invalid/duplicate-tables.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/empty-implicit-table.toml" "crates/test-suite/tests/invalid/empty-implicit-table.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/empty-table.toml" "crates/test-suite/tests/invalid/empty-table.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/float-no-leading-zero.toml" "crates/test-suite/tests/invalid/float-no-leading-zero.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/float-no-suffix.toml" "crates/test-suite/tests/invalid/float-no-suffix.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/float-no-trailing-digits.toml" "crates/test-suite/tests/invalid/float-no-trailing-digits.toml"
mkdir -p "crates/test-suite/tests/invalid"
cp "/tests/crates/test-suite/tests/invalid/key-after-array.toml" "crates/test-suite/tests/invalid/key-after-array.toml"

# Copy toml_edit test files and fixtures (needed for workspace to build after fix.patch)
mkdir -p "crates/toml_edit/tests"
cp -r /tests/crates/toml_edit/tests/* "crates/toml_edit/tests/" 2>/dev/null || true
# Copy all test-suite fixture directories
cp -r /tests/crates/test-suite/tests/valid crates/test-suite/tests/ 2>/dev/null || true
cp -r /tests/crates/test-suite/tests/invalid crates/test-suite/tests/ 2>/dev/null || true
cp -r /tests/crates/test-suite/tests/invalid-encoder crates/test-suite/tests/ 2>/dev/null || true

# Run the tests for the toml_test_suite package
# Note: In Oracle mode, solve.sh has already applied fix.patch before this script runs
# The cargo test command will build dependencies as needed
cargo test -p toml_test_suite -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
