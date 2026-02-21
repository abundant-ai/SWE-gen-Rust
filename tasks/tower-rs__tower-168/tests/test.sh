#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-buffer/tests"
cp "/tests/tower-buffer/tests/buffer.rs" "tower-buffer/tests/buffer.rs"

# Build tests to validate that the type signatures are correct
# We cannot run the tests due to futures 0.1 Task panics on Rust 1.70,
# but successful compilation proves the API changes (Mock<T, U> instead of Mock<T, U, E>)
cargo test --test buffer --manifest-path tower-buffer/Cargo.toml --no-run
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
