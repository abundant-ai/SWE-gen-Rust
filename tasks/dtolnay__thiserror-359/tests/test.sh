#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/ui"
cp "/tests/ui/unconditional-recursion.rs" "tests/ui/unconditional-recursion.rs"
mkdir -p "tests/ui"
cp "/tests/ui/unconditional-recursion.stderr" "tests/ui/unconditional-recursion.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Create a temporary test file to run only the specific UI test
cat > /tmp/test_unconditional_recursion.rs << 'EOF'
#[rustversion::attr(not(nightly), ignore = "requires nightly")]
#[cfg_attr(miri, ignore = "incompatible with miri")]
#[test]
fn ui_unconditional_recursion() {
    let t = trybuild::TestCases::new();
    t.compile_fail("tests/ui/unconditional-recursion.rs");
}
EOF

# Copy the temporary test to the tests directory
cp /tmp/test_unconditional_recursion.rs tests/test_unconditional_recursion.rs

# Run only the specific test for this PR
cargo test --test test_unconditional_recursion
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
