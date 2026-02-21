#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls-fuzzing-provider/tests"
cp "/tests/rustls-fuzzing-provider/tests/smoke.rs" "rustls-fuzzing-provider/tests/smoke.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api_ffdhe.rs" "rustls/tests/api_ffdhe.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/client_cert_verifier.rs" "rustls/tests/client_cert_verifier.rs"
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/key_log_file_env.rs" "rustls/tests/key_log_file_env.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/server_cert_verifier.rs" "rustls/tests/server_cert_verifier.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/unbuffered.rs" "rustls/tests/unbuffered.rs"

# Run tests for the specific test files from the PR
# For Rust integration tests, we use --test flag with the test file name (without .rs extension)
# Note: smoke test is in rustls-fuzzing-provider package, others are in rustls package
cargo test -p rustls-fuzzing-provider --test smoke -- --nocapture && \
cargo test -p rustls --test api -- --nocapture && \
cargo test -p rustls --test api_ffdhe -- --nocapture && \
cargo test -p rustls --test client_cert_verifier -- --nocapture && \
cargo test -p rustls --test key_log_file_env -- --nocapture && \
cargo test -p rustls --test server_cert_verifier -- --nocapture && \
cargo test -p rustls --test unbuffered -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
