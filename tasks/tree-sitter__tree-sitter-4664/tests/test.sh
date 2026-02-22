#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/fuzz"
cp "/tests/crates/cli/src/fuzz/corpus_test.rs" "crates/cli/src/fuzz/corpus_test.rs"

# Test that the code compiles with the updated API
# The fix changes Node::child() and Node::named_child() to accept u32 instead of usize
# This should allow the code to compile without type mismatches
cargo build --release
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
