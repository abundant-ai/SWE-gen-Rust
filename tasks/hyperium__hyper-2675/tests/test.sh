#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Fix support/mod.rs to remove unused StatusCode import (causes error with #![deny(warnings)])
sed -i 's/pub use hyper::{HeaderMap, StatusCode};/pub use hyper::HeaderMap;/' tests/support/mod.rs

# Run the server test file
cargo test --test server --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
