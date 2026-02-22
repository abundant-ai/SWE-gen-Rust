#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/display_tricky.rs" "crates/toml/tests/testsuite/display_tricky.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/pretty.rs" "crates/toml/tests/testsuite/pretty.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/serde.rs" "crates/toml/tests/testsuite/serde.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/tables_last.rs" "crates/toml/tests/testsuite/tables_last.rs"

# Run tests in the testsuite (which includes all the modified test files)
output=$(cargo test -p toml --test testsuite -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No testsuite tests ran in toml package." >&2
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
