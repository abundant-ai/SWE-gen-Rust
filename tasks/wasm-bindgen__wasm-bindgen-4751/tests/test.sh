#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/try_from_js_value.rs" "tests/wasm/try_from_js_value.rs"
cp "/tests/wasm/try_from_js_value.js" "tests/wasm/try_from_js_value.js"

# Run test for try_from_js_value module
cargo test --target wasm32-unknown-unknown "(try_from_js_value::)" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
