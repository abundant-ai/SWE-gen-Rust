#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive"
cp "/tests/derive/markdown.rs" "tests/derive/markdown.rs"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/blocks.term.svg" "tests/derive/snapshots/blocks.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/headers.term.svg" "tests/derive/snapshots/headers.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/html.term.svg" "tests/derive/snapshots/html.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/inline_styles.term.svg" "tests/derive/snapshots/inline_styles.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/links.term.svg" "tests/derive/snapshots/links.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/lists.term.svg" "tests/derive/snapshots/lists.term.svg"
mkdir -p "tests/derive/snapshots"
cp "/tests/derive/snapshots/paragraphs.term.svg" "tests/derive/snapshots/paragraphs.term.svg"

# Run specific tests from the modified test file
# Test is in: tests/derive/markdown.rs (gated by #![cfg(feature = "unstable-markdown")])
# The 'derive' is the test target that includes this file
# Note: In BASE state, unstable-markdown feature doesn't exist, so tests won't compile/run
# In HEAD state (with Oracle agent applying fix.patch), feature exists and tests will run
cargo test --test derive --features help,usage,error-context,derive,unstable-markdown -- --nocapture markdown::
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
