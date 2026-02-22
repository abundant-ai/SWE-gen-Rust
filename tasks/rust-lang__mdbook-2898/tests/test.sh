#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-unusual-levels.goml" "tests/gui/heading-nav-unusual-levels.goml"

# Run ALL GUI tests to see if any pass with the fix applied
cargo test --locked --test gui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
