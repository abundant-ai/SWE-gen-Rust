#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy the deprecated test file
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/deprecated.rs" "test_suite/tests/deprecated.rs"

# Build serde and serde_derive first
cd serde && cargo build
cd ../serde_derive && cargo build

# Now compile the deprecated test directly using rustc to avoid cargo's dev-dependencies
cd ../test_suite
rustc --crate-type lib --edition 2021 \
  --extern serde_derive=../target/debug/libserde_derive.so \
  --extern serde=../target/debug/libserde.rlib \
  -L dependency=../target/debug/deps \
  tests/deprecated.rs
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
