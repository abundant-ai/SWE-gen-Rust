#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/client"
cp "/tests/src/client/tests.rs" "src/client/tests.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run integration test from tests/client.rs
cargo test --test client -- --nocapture
test_status_1=$?

# Run unit tests from src/client/tests.rs (part of the client module)
cargo test --lib client::tests -- --nocapture
test_status_2=$?

# Overall test status - fail if either fails
if [ $test_status_1 -eq 0 ] && [ $test_status_2 -eq 0 ]; then
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
