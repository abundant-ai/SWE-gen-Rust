#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test file from /tests (overwrites BASE state)
mkdir -p "tests/support"
cp "/tests/support/crl.pem" "tests/support/crl.pem"

# Run the specific CRL-related tests with rustls feature enabled
# The test should exist and pass in the fixed state, but not exist in the buggy state
output=$(cargo test crl_from_pem --features "rustls-tls" -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if at least one test ran (not filtered out)
if [ $test_status -eq 0 ] && echo "$output" | grep -E "test result:.*[1-9][0-9]* passed" > /dev/null; then
  echo 1 > /logs/verifier/reward.txt
  exit 0
else
  echo 0 > /logs/verifier/reward.txt
  exit 1
fi
