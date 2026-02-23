#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/cli"
cp "/tests/cli/init.rs" "tests/cli/init.rs"
mkdir -p "tests/cli"
cp "/tests/cli/mod.rs" "tests/cli/mod.rs"

# Test that --force flag works correctly by checking that prompts don't appear
# Create a temp directory for testing
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Run mdbook init --force and capture output
OUTPUT=$(timeout 5 /app/src/target/debug/mdbook init --force 2>&1)
EXIT_CODE=$?

# Check that it succeeded
if [ $EXIT_CODE -ne 0 ]; then
  echo "mdbook init --force failed with exit code $EXIT_CODE"
  test_status=1
# Check that prompts do NOT appear in output (this is what --force should prevent)
elif echo "$OUTPUT" | grep -q "Do you want a .gitignore to be created"; then
  echo "FAIL: Prompt for .gitignore appeared despite --force flag"
  echo "Output was:"
  echo "$OUTPUT"
  test_status=1
elif echo "$OUTPUT" | grep -q "What title would you like to give the book"; then
  echo "FAIL: Prompt for title appeared despite --force flag"
  echo "Output was:"
  echo "$OUTPUT"
  test_status=1
elif ! echo "$OUTPUT" | grep -q "All done, no errors"; then
  echo "FAIL: Expected success message not found"
  echo "Output was:"
  echo "$OUTPUT"
  test_status=1
elif [ -f "$TEMP_DIR/.gitignore" ]; then
  echo "FAIL: .gitignore was created despite --force (should default to no)"
  test_status=1
else
  echo "PASS: --force flag works correctly (no prompts, correct defaults)"
  test_status=0
fi

cd /app/src
rm -rf "$TEMP_DIR"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
