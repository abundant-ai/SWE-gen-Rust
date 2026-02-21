#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls-test/tests"
cp "/tests/rustls-test/tests/api.rs" "rustls-test/tests/api.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/api.rs" "rustls-test/tests/api/api.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/client_cert_verifier.rs" "rustls-test/tests/api/client_cert_verifier.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/crypto.rs" "rustls-test/tests/api/crypto.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/kx.rs" "rustls-test/tests/api/kx.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/quic.rs" "rustls-test/tests/api/quic.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/raw_keys.rs" "rustls-test/tests/api/raw_keys.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/resolve.rs" "rustls-test/tests/api/resolve.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/server_cert_verifier.rs" "rustls-test/tests/api/server_cert_verifier.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/unbuffered.rs" "rustls-test/tests/api/unbuffered.rs"

# Run the specific test file (api tests are in the api test binary)
cargo test --test api --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
