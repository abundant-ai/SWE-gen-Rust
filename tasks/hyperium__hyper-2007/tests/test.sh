#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"
mkdir -p "tests/support"
cp "/tests/support/mod.rs" "tests/support/mod.rs"

# Run the specific integration tests
cargo test --test client --features "runtime unstable-stream" -- --nocapture
client_status=$?

cargo test --test server --features "runtime unstable-stream" -- --nocapture
server_status=$?

# Both tests must pass
if [ $client_status -eq 0 ] && [ $server_status -eq 0 ]; then
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
