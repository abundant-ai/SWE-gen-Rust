#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/bad_lifetimes.rs" "test_suite/tests/compile-fail/borrow/bad_lifetimes.rs"
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/duplicate_lifetime.rs" "test_suite/tests/compile-fail/borrow/duplicate_lifetime.rs"
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/empty_lifetimes.rs" "test_suite/tests/compile-fail/borrow/empty_lifetimes.rs"
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/no_lifetimes.rs" "test_suite/tests/compile-fail/borrow/no_lifetimes.rs"
mkdir -p "test_suite/tests/compile-fail/borrow"
cp "/tests/test_suite/tests/compile-fail/borrow/wrong_lifetime.rs" "test_suite/tests/compile-fail/borrow/wrong_lifetime.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_borrow.rs" "test_suite/tests/test_borrow.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_borrow.rs

# Run the specific test files
cargo test --test test_borrow
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
