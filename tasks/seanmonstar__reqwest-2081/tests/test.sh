#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests/support"
cp "/tests/support/delay_server.rs" "tests/support/delay_server.rs"
mkdir -p "tests/support"
cp "/tests/support/mod.rs" "tests/support/mod.rs"
mkdir -p "tests/support"
cp "/tests/support/server.rs" "tests/support/server.rs"

# Run client test
cargo test --test client -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
