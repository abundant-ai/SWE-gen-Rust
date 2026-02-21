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
cp "/tests/rustls-test/tests/api/compress.rs" "rustls-test/tests/api/compress.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/crypto.rs" "rustls-test/tests/api/crypto.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/ffdhe.rs" "rustls-test/tests/api/ffdhe.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/io.rs" "rustls-test/tests/api/io.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/kx.rs" "rustls-test/tests/api/kx.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/quic.rs" "rustls-test/tests/api/quic.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/raw_keys.rs" "rustls-test/tests/api/raw_keys.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/resolve.rs" "rustls-test/tests/api/resolve.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/resume.rs" "rustls-test/tests/api/resume.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/server_cert_verifier.rs" "rustls-test/tests/api/server_cert_verifier.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/unbuffered.rs" "rustls-test/tests/api/unbuffered.rs"
mkdir -p "rustls-test/tests"
cp "/tests/rustls-test/tests/bogo.rs" "rustls-test/tests/bogo.rs"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P256_HKDF_SHA256-HKDF_SHA256-AES_128_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P256_HKDF_SHA256-HKDF_SHA256-AES_128_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P256_HKDF_SHA256-HKDF_SHA256-AES_256_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P256_HKDF_SHA256-HKDF_SHA256-AES_256_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P384_HKDF_SHA384-HKDF_SHA384-AES_128_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P384_HKDF_SHA384-HKDF_SHA384-AES_128_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P384_HKDF_SHA384-HKDF_SHA384-AES_256_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P384_HKDF_SHA384-HKDF_SHA384-AES_256_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P521_HKDF_SHA512-HKDF_SHA512-AES_128_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P521_HKDF_SHA512-HKDF_SHA512-AES_128_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/DHKEM_P521_HKDF_SHA512-HKDF_SHA512-AES_256_GCM-echconfigs.bin" "rustls-test/tests/data/DHKEM_P521_HKDF_SHA512-HKDF_SHA512-AES_256_GCM-echconfigs.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/bug2040-message-1.bin" "rustls-test/tests/data/bug2040-message-1.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/bug2040-message-2.bin" "rustls-test/tests/data/bug2040-message-2.bin"
mkdir -p "rustls-test/tests/data"
cp "/tests/rustls-test/tests/data/bug2227-clienthello.bin" "rustls-test/tests/data/bug2227-clienthello.bin"
mkdir -p "rustls-test/tests"
cp "/tests/rustls-test/tests/key_log_file_env.rs" "rustls-test/tests/key_log_file_env.rs"

# Run the integration tests in rustls-test package
cargo test -p rustls-test --test api --test bogo --test key_log_file_env -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
