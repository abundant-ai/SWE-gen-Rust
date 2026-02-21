#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/regression"
cp "/tests/test_suite/tests/regression/issue2844.rs" "test_suite/tests/regression/issue2844.rs"
mkdir -p "test_suite/tests/ui/with"
cp "/tests/test_suite/tests/ui/with/incorrect_type.rs" "test_suite/tests/ui/with/incorrect_type.rs"
cp "/tests/test_suite/tests/ui/with/incorrect_type.stderr" "test_suite/tests/ui/with/incorrect_type.stderr"

# Build serde and serde_derive first
cd serde && cargo build
cd ../serde_derive && cargo build

# Test 1: Regression test (should compile successfully)
cd ../test_suite
rustc --crate-type lib --edition 2021 \
  --extern serde_derive=../target/debug/libserde_derive.so \
  --extern serde=../target/debug/libserde.rlib \
  -L dependency=../target/debug/deps \
  tests/regression/issue2844.rs
test_status=$?

# If regression test failed, exit early
if [ $test_status -ne 0 ]; then
  echo 0 > /logs/verifier/reward.txt
  exit "$test_status"
fi

# Test 2: UI test (should produce specific error messages)
# Compile and capture stderr
rustc --crate-type lib --edition 2021 \
  --extern serde_derive=../target/debug/libserde_derive.so \
  --extern serde=../target/debug/libserde.rlib \
  -L dependency=../target/debug/deps \
  tests/ui/with/incorrect_type.rs 2>&1 | grep -E "^error" > /tmp/actual_errors.txt || true

# Check if we got the expected errors
grep -q "error\[E0277\].*Serializer.*is not satisfied" /tmp/actual_errors.txt
e0277=$?
grep -q "error\[E0061\].*this function takes 1 argument but 2 arguments were supplied" /tmp/actual_errors.txt
e0061=$?
grep -q "error\[E0308\].*\`?\` operator has incompatible types" /tmp/actual_errors.txt
e0308=$?

if [ $e0277 -eq 0 ] && [ $e0061 -eq 0 ] && [ $e0308 -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
