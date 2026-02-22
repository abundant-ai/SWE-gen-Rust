#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/api.rs" "tests/wasm/api.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/option.js" "tests/wasm/option.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/option.rs" "tests/wasm/option.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/try_from_js_value.rs" "tests/wasm/try_from_js_value.rs"

# Run tests for api, option, and try_from_js_value modules
# These tests need to be run with wasm32-unknown-unknown target
cargo test --target wasm32-unknown-unknown "(api::|option::|try_from_js_value::)" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
