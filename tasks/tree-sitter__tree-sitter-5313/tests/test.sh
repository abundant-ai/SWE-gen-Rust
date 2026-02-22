#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/fuzz"
cp "/tests/crates/cli/src/fuzz/corpus_test.rs" "crates/cli/src/fuzz/corpus_test.rs"
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/parser_test.rs" "crates/cli/src/tests/parser_test.rs"

# Run the specific tests that use child_count() and verify the type change compiles correctly
# These tests exercise the API change from usize to u32
# We run them separately since cargo test doesn't support multiple exact test names
cargo test --package tree-sitter-cli --lib tests::parser_test::test_parsing_on_multiple_threads -- --nocapture --show-output 2>&1
test1_status=$?
cargo test --package tree-sitter-cli --lib tests::parser_test::test_parsing_with_timeout_during_balancing -- --nocapture --show-output 2>&1
test2_status=$?

# Both must pass
if [ $test1_status -eq 0 ] && [ $test2_status -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
