#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/duplicate_variant.rs" "test_suite/tests/compile-fail/borrow/duplicate_variant.rs"
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/struct_variant.rs" "test_suite/tests/compile-fail/borrow/struct_variant.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_gen.rs" "test_suite/tests/test_gen.rs"

# Fix test_gen.rs - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_gen.rs

# Run the specific test file
cargo test --test test_gen
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
