#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-driver/src/mdbook"
cp "/tests/crates/mdbook-driver/src/mdbook/tests.rs" "crates/mdbook-driver/src/mdbook/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/book_test.rs" "tests/testsuite/book_test.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/preprocessor.rs" "tests/testsuite/preprocessor.rs"

# Run specific tests from the PR
cargo test -p mdbook-driver --lib -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  cargo test --test testsuite book_test -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test testsuite preprocessor -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
