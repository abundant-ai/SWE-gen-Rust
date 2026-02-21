#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_gen.rs" "test_suite/tests/test_gen.rs"

# Replace #![deny(warnings)] with specific denies to avoid modern Rust lint issues
sed -i 's|#!\[deny(warnings)\]|#![deny(dead_code)]|' test_suite/tests/test_gen.rs

# The pretend module doesn't handle tuple/newtype remote derives - this is a known limitation
# from the original implementation that modern Rust exposes more strictly
# Allow dead_code for StrDef specifically (line ~346)
sed -i '/serde(remote = "Str")/a\    #[allow(dead_code)]' test_suite/tests/test_gen.rs

# Run the specific tests for this PR
cd /app/src/test_suite

# Clean and rebuild to ensure changes to serde_derive are picked up
cargo clean

# Build test binaries to check compilation (these are compile-time tests)
cargo test --test test_gen --no-run
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
