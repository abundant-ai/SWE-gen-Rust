#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/ui"
cp "/tests/ui/unexpected-field-fmt.rs" "tests/ui/unexpected-field-fmt.rs"
mkdir -p "tests/ui"
cp "/tests/ui/unexpected-field-fmt.stderr" "tests/ui/unexpected-field-fmt.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/unexpected-struct-source.rs" "tests/ui/unexpected-struct-source.rs"
mkdir -p "tests/ui"
cp "/tests/ui/unexpected-struct-source.stderr" "tests/ui/unexpected-struct-source.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the UI tests (compiletest runs all UI tests in tests/ui/)
cargo test --test compiletest
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
