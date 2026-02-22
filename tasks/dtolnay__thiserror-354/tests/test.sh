#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/test_display.rs" "tests/test_display.rs"
mkdir -p "tests/ui"
cp "/tests/ui/numbered-positional-tuple.rs" "tests/ui/numbered-positional-tuple.rs"
mkdir -p "tests/ui"
cp "/tests/ui/numbered-positional-tuple.stderr" "tests/ui/numbered-positional-tuple.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Create a temporary test file to run only the specific UI test
cat > /tmp/test_numbered_positional_tuple.rs << 'EOF'
#[rustversion::attr(not(nightly), ignore = "requires nightly")]
#[cfg_attr(miri, ignore = "incompatible with miri")]
#[test]
fn ui_numbered_positional_tuple() {
    let t = trybuild::TestCases::new();
    t.compile_fail("tests/ui/numbered-positional-tuple.rs");
}
EOF

# Copy the temporary test to the tests directory
cp /tmp/test_numbered_positional_tuple.rs tests/test_numbered_positional_tuple.rs

# Run the specific UI test and test_display
cargo test --test test_numbered_positional_tuple
test_status=$?

# Also run the test_display tests
if [ $test_status -eq 0 ]; then
  cargo test --test test_display
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
