#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/macros.rs" "serde_tests/tests/macros.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_de.rs" "serde_tests/tests/test_de.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_ser.rs" "serde_tests/tests/test_ser.rs"

# Run cargo test for the serde_tests package
# The modified test files (macros.rs, test_de.rs, test_ser.rs) will be run
cd serde_tests && cargo test
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
