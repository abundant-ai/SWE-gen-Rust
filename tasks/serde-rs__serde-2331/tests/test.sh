#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/ui/remote"
cp "/tests/test_suite/tests/ui/remote/double_generic.rs" "test_suite/tests/ui/remote/double_generic.rs"
mkdir -p "test_suite/tests/ui/remote"
cp "/tests/test_suite/tests/ui/remote/double_generic.stderr" "test_suite/tests/ui/remote/double_generic.stderr"

# Run the compiletest UI tests (includes the double_generic test files)
cd /app/src/test_suite
cargo test --test compiletest -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
