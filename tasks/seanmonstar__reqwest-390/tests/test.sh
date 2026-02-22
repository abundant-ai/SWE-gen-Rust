#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"

# Fetch dependencies
cargo fetch 2>/dev/null || true

# Run the specific test file for this PR
# In BASE state (bug.patch applied): tls feature doesn't exist, so tests gated by it won't run
# In FIXED state (fix.patch applied): tls feature exists (via default-tls), all tests should run
output=$(cargo test --test badssl -- --nocapture 2>&1)
test_status=$?

# Check that the expected tests ran
# We expect test_badssl_modern and test_badssl_self_signed to run (both gated by tls feature)
if echo "$output" | grep -q "test test_badssl_modern"; then
  # Success - the tls-gated tests are present, meaning the fix is applied
  echo 1 > /logs/verifier/reward.txt
  exit_code=0
else
  # Failure - tls-gated tests are missing, meaning we're in BASE state
  echo 0 > /logs/verifier/reward.txt
  exit_code=1
fi

echo "$output"
exit "$exit_code"
