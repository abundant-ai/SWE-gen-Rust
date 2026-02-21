#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/tests.rs" "tests/tests.rs"
mkdir -p "tests"
cp "/tests/workdir.rs" "tests/workdir.rs"

# Rebuild the project to pick up any source code changes from fix.patch
# Need to build both the binary and tests since tests invoke the binary
cargo build && cargo build --tests

# Run only the specific test(s) for this PR
# The test file is tests/tests.rs but the test target is named "integration" in Cargo.toml
# Run only the "max_filesize" tests which test the --max-filesize flag added in this PR
cargo test --test integration max_filesize -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
