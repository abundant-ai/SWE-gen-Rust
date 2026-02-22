#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/parser_test.rs" "crates/cli/src/tests/parser_test.rs"
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/query_test.rs" "crates/cli/src/tests/query_test.rs"

# Test that the code compiles with the updated test files
# The fix ensures the tests can use the correct API
cargo test --no-run -p tree-sitter-cli
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
