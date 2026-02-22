#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/client_cert_verifier.rs" "rustls/tests/client_cert_verifier.rs"

# Run the specific test file (with dangerous_configuration feature)
cargo test --package rustls --test client_cert_verifier --features dangerous_configuration -- --nocapture 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
