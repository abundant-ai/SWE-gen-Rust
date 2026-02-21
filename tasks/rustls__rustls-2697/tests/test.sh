#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/resolve.rs" "rustls/tests/resolve.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run tests from both resolve and server_cert_verifier modules in the api test
cargo test --test api -- --nocapture resolve::
test_status_resolve=$?
cargo test --test api -- --nocapture server_cert_verifier::
test_status_verifier=$?

# Both must pass for overall success
if [ $test_status_resolve -eq 0 ] && [ $test_status_verifier -eq 0 ]; then
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
