#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/http3.rs" "tests/http3.rs"
mkdir -p "tests/support"
cp "/tests/support/server.rs" "tests/support/server.rs"

# Run specific integration tests (client.rs and http3.rs)
# Note: tests/support/server.rs is a support module, not a test file itself
# The http3 feature must be enabled for http3 tests to run
cargo test --test client --test http3 --features http3
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
