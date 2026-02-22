#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Run the ACL snapshot test
# This test validates the platform-specific-permissions snapshot
cargo test --package acl-tests --lib -- tests::resolve_acl --exact --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
