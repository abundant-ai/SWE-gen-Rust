#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite"
cp "/tests/testsuite/bad_manifest_path.rs" "tests/testsuite/bad_manifest_path.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/metadata.rs" "tests/testsuite/metadata.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/read_manifest.rs" "tests/testsuite/read_manifest.rs"
mkdir -p "tests/testsuite/script"
cp "/tests/testsuite/script/cargo.rs" "tests/testsuite/script/cargo.rs"

# Run the specific test modules for this PR
# The test files are tests/testsuite/{bad_manifest_path,metadata,read_manifest}.rs and tests/testsuite/script/cargo.rs
# Run each test module separately and track if any fail
test_status=0

cargo test -p cargo --test testsuite bad_manifest_path -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite metadata -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite read_manifest -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite script::cargo -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
