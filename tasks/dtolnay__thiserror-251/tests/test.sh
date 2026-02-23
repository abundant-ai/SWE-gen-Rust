#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/ui"
cp "/tests/ui/no-display.rs" "tests/ui/no-display.rs"
mkdir -p "tests/ui"
cp "/tests/ui/no-display.stderr" "tests/ui/no-display.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Create a temporary test file to run only the specific UI tests for this PR
cat > /tmp/test_no_display_ui.rs << 'EOF'
#[rustversion::attr(not(nightly), ignore = "requires nightly")]
#[cfg_attr(miri, ignore = "incompatible with miri")]
#[test]
fn ui_no_display_tests() {
    let t = trybuild::TestCases::new();
    t.compile_fail("tests/ui/no-display.rs");
}
EOF

# Copy the temporary test to the tests directory
cp /tmp/test_no_display_ui.rs tests/test_no_display_ui.rs

# Run the specific UI tests
cargo test --test test_no_display_ui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
