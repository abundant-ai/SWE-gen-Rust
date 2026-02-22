#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/consistent.rs" "tests/consistent.rs"
mkdir -p "tests"
cp "/tests/crazy.rs" "tests/crazy.rs"
mkdir -p "tests"
cp "/tests/test_default.rs" "tests/test_default.rs"

# Run the specific test files for this PR
# test_default.rs includes crazy.rs as a module
# test_crates_regex.rs includes consistent.rs as a module
cargo test --test default -- --nocapture && \
cargo test --test crates-regex -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
