#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/client_cert_verifier.rs" "rustls/tests/client_cert_verifier.rs"

# Run tests for the specific test files from this PR
cargo test --package rustls --test api -- --nocapture
api_status=$?

cargo test --package rustls --test client_cert_verifier -- --nocapture
verifier_status=$?

# Both tests need to pass
if [ $api_status -eq 0 ] && [ $verifier_status -eq 0 ]; then
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
