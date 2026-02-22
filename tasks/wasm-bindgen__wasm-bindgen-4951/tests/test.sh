#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export WASM_BINDGEN_SPLIT_LINKED_MODULES=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.js" "tests/wasm/closures.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.rs" "tests/wasm/closures.rs"

# Compile and run the immediate_closure tests from the wasm test binary
# The closures tests use ImmediateClosure which is added in the fix
# Without the fix (BASE state), compilation will fail due to missing ImmediateClosure type
# With the fix (HEAD state), compilation and tests should pass
cargo test --target wasm32-unknown-unknown --test wasm immediate_closure 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
