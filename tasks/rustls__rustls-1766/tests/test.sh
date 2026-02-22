#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"
mkdir -p "rustls/tests/common"
cp "/tests/rustls/tests/common/mod.rs" "rustls/tests/common/mod.rs"
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/process_provider.rs" "rustls/tests/process_provider.rs"

# Run tests for the specific test files from this PR
cargo test --test api --test process_provider -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
