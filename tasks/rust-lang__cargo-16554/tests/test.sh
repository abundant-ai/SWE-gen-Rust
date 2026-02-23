#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite/lints"
cp "/tests/testsuite/lints/mod.rs" "tests/testsuite/lints/mod.rs"
mkdir -p "tests/testsuite/lints"
cp "/tests/testsuite/lints/non_kebab_case_packages.rs" "tests/testsuite/lints/non_kebab_case_packages.rs"
mkdir -p "tests/testsuite/lints"
cp "/tests/testsuite/lints/non_snake_case_packages.rs" "tests/testsuite/lints/non_snake_case_packages.rs"

# Run lints tests (non_kebab_case_packages and non_snake_case_packages)
cargo test -p cargo --test testsuite lints::non_kebab_case_packages -- --nocapture && \
cargo test -p cargo --test testsuite lints::non_snake_case_packages -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
