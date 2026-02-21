#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_macros.rs" "test_suite/tests/test_macros.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_macros.rs

# Run the specific tests (test_macros module in the test target)
cargo test --test test test_macros::
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
