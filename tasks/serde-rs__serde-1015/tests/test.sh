#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_de_newtype_field.rs" "test_suite/tests/compile-fail/with-variant/skip_de_newtype_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_de_struct_field.rs" "test_suite/tests/compile-fail/with-variant/skip_de_struct_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_de_tuple_field.rs" "test_suite/tests/compile-fail/with-variant/skip_de_tuple_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_de_whole_variant.rs" "test_suite/tests/compile-fail/with-variant/skip_de_whole_variant.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_newtype_field.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_newtype_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_newtype_field_if.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_newtype_field_if.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_struct_field.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_struct_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_struct_field_if.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_struct_field_if.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_tuple_field.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_tuple_field.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_tuple_field_if.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_tuple_field_if.rs"
mkdir -p "test_suite/tests/compile-fail/with-variant"
cp "/tests/test_suite/tests/compile-fail/with-variant/skip_ser_whole_variant.rs" "test_suite/tests/compile-fail/with-variant/skip_ser_whole_variant.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_gen.rs" "test_suite/tests/test_gen.rs"

# Fix test_gen.rs - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_gen.rs

# Run the specific test files
cargo test --test test_annotations --test test_gen
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
