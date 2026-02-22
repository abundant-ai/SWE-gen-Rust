#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/macros_bytes.rs" "tests/macros_bytes.rs"
mkdir -p "tests"
cp "/tests/macros_str.rs" "tests/macros_str.rs"
mkdir -p "tests"
cp "/tests/replace.rs" "tests/replace.rs"

# Run the specific test files for this PR
# macros_str.rs and replace.rs are included in test_default.rs
# macros_bytes.rs and replace.rs are included in test_default_bytes.rs
cargo test --test default -- --nocapture && \
cargo test --test default-bytes -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
