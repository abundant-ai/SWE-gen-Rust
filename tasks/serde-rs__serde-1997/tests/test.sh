#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de.rs" "test_suite/tests/test_de.rs"

# Allow dead code to avoid errors from unused helper code in the test file
sed -i '2a #![allow(dead_code)]' "test_suite/tests/test_de.rs"

# Run the test_de test
cd /app/src/test_suite
cargo test --test test_de -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
