#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"

# The bug makes ClientSessionStore trait methods conditional on tls12 feature
# The HEAD test file has implementations that are NOT conditional
# When compiling without tls12, the buggy version should fail because
# the impl tries to implement methods that aren't in the trait

# Try to compile the api test (which includes ClientStorage impl) without tls12 feature
cargo test --package rustls --test api --no-default-features --features=logging --no-run 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
