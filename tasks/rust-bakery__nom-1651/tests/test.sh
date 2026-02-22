#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/bytes"
cp "/tests/src/bytes/tests.rs" "src/bytes/tests.rs"
cp "/tests/src/bytes/complete.rs" "src/bytes/complete.rs"

# Run the multibyte UTF-8 test that verifies take_while_m_n works correctly with multibyte characters
cargo test --lib bytes::complete::tests::complete_take_while_m_n_multibyte --features alloc -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
