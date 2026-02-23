#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/dummy_book/src"
cp "/tests/dummy_book/src/SUMMARY.md" "tests/dummy_book/src/SUMMARY.md"
mkdir -p "tests/dummy_book/src/first"
cp "/tests/dummy_book/src/first/heading-attributes.md" "tests/dummy_book/src/first/heading-attributes.md"
mkdir -p "tests"
cp "/tests/rendered_output.rs" "tests/rendered_output.rs"
mkdir -p "tests"
cp "/tests/searchindex_fixture.json" "tests/searchindex_fixture.json"

# Run the rendered_output integration test
cargo test --test rendered_output -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
