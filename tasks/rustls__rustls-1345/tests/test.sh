#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"

# Build the tests to verify that with_client_auth_cert compiles successfully
# The common module is used by tests, so compiling tests will verify the API exists
cargo test --package rustls --no-run
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
