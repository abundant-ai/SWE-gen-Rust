#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/Array.rs" "crates/js-sys/tests/wasm/Array.rs"

# Run js-sys tests with wasm32 target, filtering for Array module tests
cargo test --target wasm32-unknown-unknown -p js-sys Array::of -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
