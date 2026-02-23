#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-markdown/src"
cp "/tests/crates/mdbook-markdown/src/tests.rs" "crates/mdbook-markdown/src/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/markdown.rs" "tests/testsuite/markdown.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/search.rs" "tests/testsuite/search.rs"
mkdir -p "tests/testsuite/search/reasonable_search_index"
cp "/tests/testsuite/search/reasonable_search_index/expected_index.js" "tests/testsuite/search/reasonable_search_index/expected_index.js"

# Run tests from mdbook-markdown crate (unit tests in src/tests.rs)
cargo test -p mdbook-markdown -- --nocapture
test_status=$?

# If first test passed, run integration tests from the testsuite
# markdown and search are modules in the integration test crate
if [ $test_status -eq 0 ]; then
  cargo test --test testsuite markdown:: -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test testsuite search:: -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
