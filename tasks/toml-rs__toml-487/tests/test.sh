#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/enum_external_deserialize.rs" "crates/toml/tests/testsuite/enum_external_deserialize.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/macros.rs" "crates/toml/tests/testsuite/macros.rs"

# Run the specific test modules from toml crate (test files are modules in testsuite)
# Need to run each module separately since cargo test doesn't support multiple test name filters
output1=$(cargo test -p toml --test testsuite enum_external_deserialize -- --nocapture 2>&1)
status1=$?
echo "$output1"

output2=$(cargo test -p toml --test testsuite macros -- --nocapture 2>&1)
status2=$?
echo "$output2"

# Check if tests actually ran (not just 0 tests filtered)
if echo "$output1" | grep -q "running 0 tests"; then
  echo "ERROR: No enum_external_deserialize tests ran in toml package." >&2
  status1=1
fi

if echo "$output2" | grep -q "running 0 tests"; then
  echo "ERROR: No macros tests ran in toml package." >&2
  status2=1
fi

# Both test modules must pass
if [ $status1 -eq 0 ] && [ $status2 -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
