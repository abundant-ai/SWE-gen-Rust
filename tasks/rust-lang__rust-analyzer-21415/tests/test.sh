#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/rust-analyzer/tests/slow-tests"
cp "/tests/crates/rust-analyzer/tests/slow-tests/main.rs" "crates/rust-analyzer/tests/slow-tests/main.rs"

# Run only the workspace symbol test (test_exclude_config_works)
output=$(cargo test --test slow-tests test_exclude_config_works -- --nocapture 2>&1)
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
