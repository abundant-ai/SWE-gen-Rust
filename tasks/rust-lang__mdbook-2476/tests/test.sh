#!/bin/bash

cd /app/src

# Set environment variable for browser-ui-test version
export BROWSER_UI_TEST_VERSION=0.18.2

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/runner.rs" "tests/gui/runner.rs"
mkdir -p "tests/gui"
cp "/tests/gui/sidebar.goml" "tests/gui/sidebar.goml"

# Apply fix.patch to restore GUI test configuration in Cargo.toml and other files
# This is needed because bug.patch removed the GUI test, and we need to restore the configuration
# Check if patch is needed (for NOP case) or already applied (for Oracle case)
if ! grep -q '^\[\[test\]\]' Cargo.toml; then
    # Patch not applied yet, apply it
    patch -p1 < /solution/fix.patch
fi

# Restore BROWSER_UI_TEST_VERSION in CI config (bug.patch removed it, fix.patch doesn't restore it)
# The runner.rs test reads this value from the CI config file
if ! grep -q "BROWSER_UI_TEST_VERSION" .github/workflows/main.yml; then
    # Add the env section after the "merge_group:" line
    sed -i '/^  merge_group:/a\\nenv:\n  BROWSER_UI_TEST_VERSION: '\''0.18.2'\''' .github/workflows/main.yml
fi

# Rebuild to pick up the Cargo.toml changes
cargo build --locked

# Run the GUI test (this is a special test binary that runs browser-ui-test)
cargo test --locked --test gui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
