#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "examples/tests"
cp "/tests/examples/tests/badssl.rs" "examples/tests/badssl.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/client_cert_verifier.rs" "rustls/tests/client_cert_verifier.rs"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"

# Run the specific test files for this PR
# For badssl, run only the too_many_sans test which is the one that tests the fix
cargo test --test badssl too_many_sans 2>&1 && \
cargo test --package rustls --test client_cert_verifier 2>&1 && \
cargo test --package rustls --test server_cert_verifier 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
