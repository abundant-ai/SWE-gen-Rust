#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests-build/tests/fail"
cp "/tests/tests-build/tests/fail/macros_type_mismatch.stderr" "tests-build/tests/fail/macros_type_mismatch.stderr"
mkdir -p "tests-build/tests/pass"
cp "/tests/tests-build/tests/pass/impl_trait.rs" "tests-build/tests/pass/impl_trait.rs"

# Run the trybuild test that checks the compile-fail and pass tests
cd tests-build
cargo test --features full compile_fail_full
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
