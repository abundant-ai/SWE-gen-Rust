#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "provider-example/tests"
cp "/tests/provider-example/tests/hpke.rs" "provider-example/tests/hpke.rs"

# Run tests for the specific test files from this PR
cargo test --package rustls-provider-example --test hpke -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
