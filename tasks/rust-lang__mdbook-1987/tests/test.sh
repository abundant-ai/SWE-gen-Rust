#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/init.rs" "tests/init.rs"
mkdir -p "tests"
cp "/tests/rendered_output.rs" "tests/rendered_output.rs"

# Run only the specific test files (init and rendered_output)
cargo test --test init --test rendered_output -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
