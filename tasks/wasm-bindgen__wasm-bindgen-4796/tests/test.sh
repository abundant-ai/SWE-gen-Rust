#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/classes.js" "tests/wasm/classes.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/classes.rs" "tests/wasm/classes.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/struct_vecs.rs" "tests/wasm/struct_vecs.rs"

# Run tests for classes and struct_vecs modules
# These tests need to be run with wasm32-unknown-unknown target
# Use regex to match both classes:: and struct_vecs:: test modules
cargo test --target wasm32-unknown-unknown "(classes::|struct_vecs::)" -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
