#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/bad_getter.rs" "test_suite/tests/compile-fail/remote/bad_getter.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/bad_remote.rs" "test_suite/tests/compile-fail/remote/bad_remote.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/enum_getter.rs" "test_suite/tests/compile-fail/remote/enum_getter.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/missing_field.rs" "test_suite/tests/compile-fail/remote/missing_field.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/nonremote_getter.rs" "test_suite/tests/compile-fail/remote/nonremote_getter.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/unknown_field.rs" "test_suite/tests/compile-fail/remote/unknown_field.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/wrong_de.rs" "test_suite/tests/compile-fail/remote/wrong_de.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/wrong_getter.rs" "test_suite/tests/compile-fail/remote/wrong_getter.rs"
mkdir -p "test_suite/tests/compile-fail/remote"
cp "/tests/test_suite/tests/compile-fail/remote/wrong_ser.rs" "test_suite/tests/compile-fail/remote/wrong_ser.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_remote.rs" "test_suite/tests/test_remote.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_remote.rs

# Run the specific test files
cargo test --test test_remote
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
