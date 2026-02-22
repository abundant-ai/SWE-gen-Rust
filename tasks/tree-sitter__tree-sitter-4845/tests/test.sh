#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/corpus_test.rs" "crates/cli/src/tests/corpus_test.rs"
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/helpers.rs" "crates/cli/src/tests/helpers.rs"
# Remove the duplicate allocations module that was added by bug.patch
rm -f "crates/cli/src/tests/helpers/allocations.rs"

# Run the specific corpus tests (testing the language corpus functions that use allocation tracking)
cargo test --lib tests::corpus_test::test_corpus_for -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
