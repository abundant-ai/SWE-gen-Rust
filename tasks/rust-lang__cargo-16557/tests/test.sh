#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "src/cargo/ops"
cp "/tests/src/cargo/ops/cargo_test.rs" "src/cargo/ops/cargo_test.rs"
mkdir -p "tests/build-std"
cp "/tests/build-std/main.rs" "tests/build-std/main.rs"
mkdir -p "tests/testsuite/cargo/z_help"
cp "/tests/testsuite/cargo/z_help/stdout.term.svg" "tests/testsuite/cargo/z_help/stdout.term.svg"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/custom_target.rs" "tests/testsuite/custom_target.rs"

# Run build-std and custom_target tests
cargo test --test build-std -- --nocapture && \
cargo test -p cargo --test testsuite custom_target -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
