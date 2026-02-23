#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/ui"
cp "/tests/ui/duplicate-source.rs" "tests/ui/duplicate-source.rs"
mkdir -p "tests/ui"
cp "/tests/ui/duplicate-source.stderr" "tests/ui/duplicate-source.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the compiletest test which handles UI tests
cargo test --test compiletest
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
