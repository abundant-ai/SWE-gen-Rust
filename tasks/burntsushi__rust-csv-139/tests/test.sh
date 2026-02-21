#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/tests.rs" "tests/tests.rs"

# Run only the specific tests added in PR #139
# These tests check for correct PartialEq implementation in ByteRecord and StringRecord
# Use a pattern to match both tests
cargo test --test tests --examples eq_field_boundaries -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
