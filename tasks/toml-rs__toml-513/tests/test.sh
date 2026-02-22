#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/serde.rs" "crates/toml/tests/testsuite/serde.rs"

# Run the serde tests from toml crate (test file is in testsuite)
output=$(cargo test -p toml --test testsuite serde -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if the tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No serde tests ran in toml package." >&2
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
