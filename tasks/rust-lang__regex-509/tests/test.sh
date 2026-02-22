#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/macros_bytes.rs" "tests/macros_bytes.rs"
mkdir -p "tests"
cp "/tests/macros_str.rs" "tests/macros_str.rs"
mkdir -p "tests"
cp "/tests/replace.rs" "tests/replace.rs"

# Run the test targets that include these modified files
# macros_bytes.rs and macros_str.rs are included in default and default-bytes tests
# replace.rs is included in default and default-bytes tests
cargo test --test default --test default-bytes -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
