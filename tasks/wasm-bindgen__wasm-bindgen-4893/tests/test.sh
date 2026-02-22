#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/headless"
cp "/tests/headless/main.rs" "tests/headless/main.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.rs" "tests/wasm/closures.rs"

# Build (compile) the specific integration tests to verify they compile successfully
# These tests verify UnwindSafe bounds are enforced - they're compile-time checks
cargo +nightly build --target wasm32-unknown-unknown -Zbuild-std=std,panic_abort --test headless 2>&1 && \
cargo +nightly build --target wasm32-unknown-unknown -Zbuild-std=std,panic_abort --test wasm --features std,wasm-bindgen-futures/std 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
