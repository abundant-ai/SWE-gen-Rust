#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/float.rs" "crates/toml/tests/testsuite/float.rs"
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/float.rs" "crates/toml_edit/tests/testsuite/float.rs"
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/main.rs" "crates/toml_edit/tests/testsuite/main.rs"

# Run the float tests from both toml and toml_edit crates
# Note: cargo test will run the testsuite integration test which includes float.rs
output=$(cargo test -p toml --test testsuite -- --nocapture 2>&1)
test_status_toml=$?
echo "$output"

output2=$(cargo test -p toml_edit --test testsuite -- --nocapture 2>&1)
test_status_edit=$?
echo "$output2"

# Check if the tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No tests ran in toml package. The float tests should exist." >&2
  test_status_toml=1
fi

if echo "$output2" | grep -q "running 0 tests"; then
  echo "ERROR: No tests ran in toml_edit package. The float tests should exist." >&2
  test_status_edit=1
fi

# Overall test status (both must pass)
test_status=$((test_status_toml || test_status_edit))

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
