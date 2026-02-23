#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite/rendering/header_links/expected"
cp "/tests/testsuite/rendering/header_links/expected/header_links.html" "tests/testsuite/rendering/header_links/expected/header_links.html"

# Run the specific header_links test
cargo test --test testsuite rendering::header_links -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
