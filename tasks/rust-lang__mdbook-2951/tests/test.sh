#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite/rendering/fontawesome/expected"
cp "/tests/testsuite/rendering/fontawesome/expected/fa.html" "tests/testsuite/rendering/fontawesome/expected/fa.html"
mkdir -p "tests/testsuite/rendering/fontawesome/src"
cp "/tests/testsuite/rendering/fontawesome/src/fa.md" "tests/testsuite/rendering/fontawesome/src/fa.md"

# Run the specific fontawesome test
cargo test fontawesome -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
