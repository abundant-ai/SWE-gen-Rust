#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/hir-ty/src/tests/regression"
cp "/tests/crates/hir-ty/src/tests/regression/new_solver.rs" "crates/hir-ty/src/tests/regression/new_solver.rs"

# Run tests for new_solver module in hir-ty
cargo test -p hir-ty --lib new_solver -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
