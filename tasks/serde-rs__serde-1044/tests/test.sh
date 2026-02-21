#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/macros"
cp "/tests/test_suite/tests/macros/mod.rs" "test_suite/tests/macros/mod.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de.rs" "test_suite/tests/test_de.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_roundtrip.rs" "test_suite/tests/test_roundtrip.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_ser.rs" "test_suite/tests/test_ser.rs"

# Fix test_gen.rs - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_gen.rs

# Fix test_ser.rs - allow invalid_from_utf8_unchecked lint at the top of the file
sed -i '1i#![allow(invalid_from_utf8_unchecked)]' test_suite/tests/test_ser.rs

# Run the specific test files
cargo test --test test_macros --test test_de --test test_roundtrip --test test_ser
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
