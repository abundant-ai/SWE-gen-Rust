#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/api.rs" "rustls-test/tests/api/api.rs"
mkdir -p "rustls-test/tests/api"
cp "/tests/rustls-test/tests/api/io.rs" "rustls-test/tests/api/io.rs"

# Run the specific test file (api tests are in the api test binary)
cargo test --test api --all-features -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
