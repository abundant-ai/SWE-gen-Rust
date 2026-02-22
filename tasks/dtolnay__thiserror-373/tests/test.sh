#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests
mkdir -p "tests/no-std"
cp "/tests/no-std/Cargo.toml" "tests/no-std/Cargo.toml"
cp "/tests/no-std/test.rs" "tests/no-std/test.rs"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the specific test in the no-std directory
cd tests/no-std
cargo test
test_status=$?
cd /app/src

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
