#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de.rs" "test_suite/tests/test_de.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_ser.rs" "test_suite/tests/test_ser.rs"

# Run the specific tests for this PR
cd /app/src/test_suite
cargo test --test test_de -- --nocapture
test_status_de=$?
cargo test --test test_ser -- --nocapture
test_status_ser=$?

# Both tests must pass
if [ $test_status_de -eq 0 ] && [ $test_status_ser -eq 0 ]; then
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
