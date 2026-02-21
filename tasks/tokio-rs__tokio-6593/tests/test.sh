#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_test.rs" "tokio/tests/macros_test.rs"

# Rebuild tokio-macros to pick up changes from fix.patch
cd tokio-macros
cargo build
cd ..

# Run the macros_test integration tests with tokio_unstable enabled
# In BASE: This will FAIL to compile because unhandled_panic attribute doesn't exist
# In HEAD: This will compile and tests will pass
cd tokio
RUSTFLAGS='--cfg tokio_unstable' timeout 300 cargo test --test macros_test --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
