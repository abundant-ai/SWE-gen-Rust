#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests-build/tests/fail"
cp "/tests/tests-build/tests/fail/macros_join.rs" "tests-build/tests/fail/macros_join.rs"
mkdir -p "tests-build/tests/fail"
cp "/tests/tests-build/tests/fail/macros_join.stderr" "tests-build/tests/fail/macros_join.stderr"
mkdir -p "tests-build/tests/fail"
cp "/tests/tests-build/tests/fail/macros_try_join.rs" "tests-build/tests/fail/macros_try_join.rs"
mkdir -p "tests-build/tests/fail"
cp "/tests/tests-build/tests/fail/macros_try_join.stderr" "tests-build/tests/fail/macros_try_join.stderr"
mkdir -p "tests-build/tests"
cp "/tests/tests-build/tests/macros.rs" "tests-build/tests/macros.rs"

# Run the specific test for macros with required features
cd tests-build
cargo test --test macros --features full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
