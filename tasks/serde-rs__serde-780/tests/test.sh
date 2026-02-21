#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/default-attribute"
cp "/tests/test_suite/tests/compile-fail/default-attribute/enum.rs" "test_suite/tests/compile-fail/default-attribute/enum.rs"
mkdir -p "test_suite/tests/compile-fail/default-attribute"
cp "/tests/test_suite/tests/compile-fail/default-attribute/nameless_struct_fields.rs" "test_suite/tests/compile-fail/default-attribute/nameless_struct_fields.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de.rs" "test_suite/tests/test_de.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_de.rs

# Run the specific tests (test_de module in the test target)
cargo test --test test test_de::
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
