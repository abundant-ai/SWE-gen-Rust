#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/async_fn.rs" "tracing-attributes/tests/async_fn.rs"
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/instrument.rs" "tracing-attributes/tests/instrument.rs"

# Rebuild tests after copying new test files (Rust is compiled)
cargo build --workspace --tests

# Run tests for the specific test files from this PR
cargo test -p tracing-attributes --test async_fn -- --nocapture && \
cargo test -p tracing-attributes --test instrument -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
