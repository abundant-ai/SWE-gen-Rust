#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/search.goml" "tests/gui/search.goml"
mkdir -p "tests/gui"
cp "/tests/gui/sidebar.goml" "tests/gui/sidebar.goml"
mkdir -p "tests/gui"
cp "/tests/gui/theme.goml" "tests/gui/theme.goml"

# Run the GUI tests using cargo test with the gui test binary
# The test runner (tests/gui/runner.rs) accepts file name filters as arguments
# We pass the base names of our test files (search, sidebar, theme) as filters
cargo test --test gui -- search sidebar theme
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
