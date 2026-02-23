#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite/lints"
cp "/tests/testsuite/lints/mod.rs" "tests/testsuite/lints/mod.rs"
mkdir -p "tests/testsuite/lints"
cp "/tests/testsuite/lints/unused_workspace_package_fields.rs" "tests/testsuite/lints/unused_workspace_package_fields.rs"

# Run the lints test module (includes all lints tests)
cargo test -p cargo --test testsuite lints -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
