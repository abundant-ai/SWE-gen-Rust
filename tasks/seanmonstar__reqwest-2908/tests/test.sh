#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/wasm_simple.rs" "tests/wasm_simple.rs"

# Run WASM tests using wasm-pack with headless Chrome
wasm-pack test --headless --chrome --features json --test wasm_simple
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
