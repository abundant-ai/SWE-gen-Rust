#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_macros.rs" "test_suite/tests/test_macros.rs"

# Run the specific test files for this PR
cargo test --test test_annotations -- --nocapture
test_status_1=$?

cargo test --test test_macros -- --nocapture
test_status_2=$?

# Both tests must pass
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
