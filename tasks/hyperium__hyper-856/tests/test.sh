#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run integration tests from tests/client.rs and tests/server.rs (without SSL features to avoid OpenSSL 3.0 incompatibility)
cargo test --test client --no-default-features -- --nocapture && \
cargo test --test server --no-default-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
