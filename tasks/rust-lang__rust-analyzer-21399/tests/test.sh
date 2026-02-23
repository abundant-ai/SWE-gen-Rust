#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/hir-ty/src/tests/regression"
cp "/tests/crates/hir-ty/src/tests/regression/new_solver.rs" "crates/hir-ty/src/tests/regression/new_solver.rs"

# Run only the regression_19339 test from new_solver.rs
output=$(cargo test --package hir-ty regression_19339 -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if tests actually ran (not just "0 tests")
if echo "$output" | grep -q "running 0 tests"; then
  # No tests found - this means test infrastructure is missing (BASE state)
  echo "ERROR: No tests found. Test infrastructure appears to be missing." >&2
  echo 0 > /logs/verifier/reward.txt
  exit 1
elif [ $test_status -eq 0 ]; then
  # Tests ran and passed
  echo 1 > /logs/verifier/reward.txt
  exit 0
else
  # Tests ran but failed
  echo 0 > /logs/verifier/reward.txt
  exit 1
fi
