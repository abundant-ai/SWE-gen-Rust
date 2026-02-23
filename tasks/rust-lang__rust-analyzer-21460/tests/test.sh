#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/hir-ty/src/tests"
cp "/tests/crates/hir-ty/src/tests/patterns.rs" "crates/hir-ty/src/tests/patterns.rs"
mkdir -p "crates/hir-ty/src/tests"
cp "/tests/crates/hir-ty/src/tests/simple.rs" "crates/hir-ty/src/tests/simple.rs"

# Run tests for patterns module in hir-ty
cargo test -p hir-ty --lib patterns -- --nocapture
patterns_status=$?

# Run tests for simple module in hir-ty
cargo test -p hir-ty --lib simple -- --nocapture
simple_status=$?

# Both test modules must pass
if [ $patterns_status -eq 0 ] && [ $simple_status -eq 0 ]; then
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
