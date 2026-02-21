#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/type-attribute"
cp "/tests/test_suite/tests/compile-fail/type-attribute/type_attribute_fail_from.rs" "test_suite/tests/compile-fail/type-attribute/type_attribute_fail_from.rs"
mkdir -p "test_suite/tests/compile-fail/type-attribute"
cp "/tests/test_suite/tests/compile-fail/type-attribute/type_attribute_fail_into.rs" "test_suite/tests/compile-fail/type-attribute/type_attribute_fail_into.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/compile-fail/type-attribute/type_attribute_fail_from.rs
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/compile-fail/type-attribute/type_attribute_fail_into.rs
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_annotations.rs

# Run the specific test - test_annotations contains tests for these attributes
cargo test --test test_annotations
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
