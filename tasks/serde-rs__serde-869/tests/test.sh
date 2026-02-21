#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_value.rs" "test_suite/tests/test_value.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_value.rs

# Run the specific test files
cargo test --test test_value
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
