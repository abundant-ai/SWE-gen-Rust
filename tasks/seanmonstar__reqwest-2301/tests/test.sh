#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/proxy.rs" "tests/proxy.rs"
mkdir -p "tests"
cp "/tests/redirect.rs" "tests/redirect.rs"
mkdir -p "tests"
cp "/tests/timeouts.rs" "tests/timeouts.rs"
mkdir -p "tests"
cp "/tests/upgrade.rs" "tests/upgrade.rs"

# Run the specific test files for this PR with the rustls-tls-manual-roots-no-provider feature
# In BASE state (buggy): Tests don't have cfg guard, will try to run and may fail due to missing provider
# In HEAD state (fixed): Tests have cfg guard, will be excluded when this feature is used
output=$(cargo test --test badssl --test client --test proxy --test redirect --test timeouts --test upgrade --features "rustls-tls-manual-roots-no-provider" -- --nocapture 2>&1)
test_status=$?
echo "$output"

# The tests should be filtered out (not run) in the fixed state
# If tests actually run, it means the cfg guard is missing (BASE state)
if echo "$output" | grep -E "0 passed.*0 filtered out" > /dev/null; then
  # All tests filtered out = good (HEAD state with cfg guards)
  echo 1 > /logs/verifier/reward.txt
  exit 0
else
  # Tests ran or failed = bad (BASE state without cfg guards)
  echo 0 > /logs/verifier/reward.txt
  exit 1
fi
