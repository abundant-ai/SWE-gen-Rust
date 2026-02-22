#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "connect-tests/tests"
cp "/tests/connect-tests/tests/ech.rs" "connect-tests/tests/ech.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/ech.rs" "rustls/tests/ech.rs"

# Run tests for the specific test files from this PR
# Running both rustls and connect-tests packages with ech tests
cargo test --package rustls --test ech -- --nocapture
rustls_status=$?

cargo test --package rustls-connect-tests --test ech -- --nocapture
connect_status=$?

# Both tests need to pass
if [ $rustls_status -eq 0 ] && [ $connect_status -eq 0 ]; then
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
