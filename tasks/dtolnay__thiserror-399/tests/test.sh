#!/bin/bash

cd /app/src

# Set environment variables
# Allow newer lints and renamed lints not present when this code was written
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_display.rs" "tests/test_display.rs"

# Run clippy on the specific test file (these are lint tests that check macro-generated code)
cargo clippy --test test_display
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
