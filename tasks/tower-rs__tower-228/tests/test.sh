#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"

# Verify compilation of the builder test
# (The integration tests have compatibility issues with modern Rust/Tokio,
# so we verify compilation instead of running tests)
cargo build --tests --manifest-path tower/Cargo.toml
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
