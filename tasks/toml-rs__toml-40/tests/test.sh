#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_edit.rs" "tests/test_edit.rs"

# Fix bare trait object warnings that fail compilation with newer Rust
sed -i 's/fn visit_table(f: &mut Write,/fn visit_table(f: \&mut dyn Write,/' src/display.rs

# Rebuild tests after copying test files
cargo build --workspace --all-targets 2>&1

# Run the specific test file for this PR
cargo test --test test_edit 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
