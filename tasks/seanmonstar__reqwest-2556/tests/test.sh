#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/wasm_simple.rs" "tests/wasm_simple.rs"

# Remove browser-only configuration to allow tests to run in Node.js
sed -i '/wasm_bindgen_test_configure!(run_in_browser)/d' "tests/wasm_simple.rs"

# Run WASM tests using wasm-pack with Node.js (simpler than headless Chrome in Docker)
wasm-pack test --node
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
