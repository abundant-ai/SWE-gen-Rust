#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/conflict"
cp "/tests/test_suite/tests/compile-fail/conflict/flatten-skip-deserializing.rs" "test_suite/tests/compile-fail/conflict/flatten-skip-deserializing.rs"
mkdir -p "test_suite/tests/compile-fail/conflict"
cp "/tests/test_suite/tests/compile-fail/conflict/flatten-skip-serializing-if.rs" "test_suite/tests/compile-fail/conflict/flatten-skip-serializing-if.rs"
mkdir -p "test_suite/tests/compile-fail/conflict"
cp "/tests/test_suite/tests/compile-fail/conflict/flatten-skip-serializing.rs" "test_suite/tests/compile-fail/conflict/flatten-skip-serializing.rs"
mkdir -p "test_suite/tests/compile-fail/enum-representation"
cp "/tests/test_suite/tests/compile-fail/enum-representation/flatten-enum.rs" "test_suite/tests/compile-fail/enum-representation/flatten-enum.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"

# Build the deps crate first (required for compiletest to find serde_derive)
cd /app/src/test_suite/deps
cargo build

# Run the specific compile-fail tests using compiletest with filter
cd /app/src/test_suite

# Run compile-fail tests with filter for flatten-skip tests and flatten-enum
export TESTNAME="flatten-skip|flatten-enum"
cargo test --test compiletest --features unstable compile_fail

# Also run the test_annotations.rs test
cargo test --test test_annotations
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
