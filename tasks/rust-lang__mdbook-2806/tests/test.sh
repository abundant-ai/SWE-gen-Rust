#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/build.rs" "tests/testsuite/build.rs"

# Run the specific tests from the build module in testsuite
# The testsuite is a single integration test with multiple modules
# We need to run only the tests in the build module
cargo test --test testsuite --locked build:: -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
