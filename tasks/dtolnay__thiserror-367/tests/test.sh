#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_display.rs" "tests/test_display.rs"
mkdir -p "tests/ui"
cp "/tests/ui/concat-display.stderr" "tests/ui/concat-display.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/duplicate-fmt.rs" "tests/ui/duplicate-fmt.rs"
mkdir -p "tests/ui"
cp "/tests/ui/duplicate-fmt.stderr" "tests/ui/duplicate-fmt.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/struct-with-fmt.rs" "tests/ui/struct-with-fmt.rs"
mkdir -p "tests/ui"
cp "/tests/ui/struct-with-fmt.stderr" "tests/ui/struct-with-fmt.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Run the specific tests for this PR
# This PR modifies display formatting tests, including UI tests
cargo test --test test_display
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
