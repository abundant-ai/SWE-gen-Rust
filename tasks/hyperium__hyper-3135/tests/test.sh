#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
# These test files use the fixed API (Builder::new(executor))
# which won't compile with the buggy code
cp "/tests/client.rs" "tests/client.rs"
cp "/tests/server.rs" "tests/server.rs"
cp "/tests/support/mod.rs" "tests/support/mod.rs"

# Fix support/mod.rs to remove unused StatusCode import (causes error with #![deny(warnings)])
sed -i 's/pub use hyper::{HeaderMap, StatusCode};/pub use hyper::HeaderMap;/' tests/support/mod.rs

# Run the client and server test files
cargo test --test client --test server --features full -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
