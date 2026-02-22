#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Remove all UI test files to isolate the specific test
rm -f tests/ui/*.rs tests/ui/*.stderr

# Copy HEAD test files from /tests
mkdir -p "tests/ui"
cp "/tests/ui/no-display.rs" "tests/ui/no-display.rs"
cp "/tests/ui/no-display.stderr" "tests/ui/no-display.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the UI compile-fail test
cargo test --test compiletest ui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
