#!/bin/bash

cd /app/src

# Set environment variables
export RUSTFLAGS="-Dwarnings -Adead-code -Arenamed-and-removed-lints"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/ui"
cp "/tests/ui/source-enum-unnamed-field-not-error.rs" "tests/ui/source-enum-unnamed-field-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/source-enum-unnamed-field-not-error.stderr" "tests/ui/source-enum-unnamed-field-not-error.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/source-struct-unnamed-field-not-error.rs" "tests/ui/source-struct-unnamed-field-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/source-struct-unnamed-field-not-error.stderr" "tests/ui/source-struct-unnamed-field-not-error.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-enum-not-error.rs" "tests/ui/transparent-enum-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-enum-not-error.stderr" "tests/ui/transparent-enum-not-error.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-enum-unnamed-field-not-error.rs" "tests/ui/transparent-enum-unnamed-field-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-enum-unnamed-field-not-error.stderr" "tests/ui/transparent-enum-unnamed-field-not-error.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-struct-not-error.rs" "tests/ui/transparent-struct-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-struct-not-error.stderr" "tests/ui/transparent-struct-not-error.stderr"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-struct-unnamed-field-not-error.rs" "tests/ui/transparent-struct-unnamed-field-not-error.rs"
mkdir -p "tests/ui"
cp "/tests/ui/transparent-struct-unnamed-field-not-error.stderr" "tests/ui/transparent-struct-unnamed-field-not-error.stderr"

# Clean and rebuild to ensure macro changes are picked up
cargo clean
cargo build

# Create a temporary test file to run only the specific UI tests for this PR
cat > /tmp/test_source_span_ui.rs << 'EOF'
#[rustversion::attr(not(nightly), ignore = "requires nightly")]
#[cfg_attr(miri, ignore = "incompatible with miri")]
#[test]
fn ui_source_span_tests() {
    let t = trybuild::TestCases::new();
    t.compile_fail("tests/ui/source-enum-unnamed-field-not-error.rs");
    t.compile_fail("tests/ui/source-struct-unnamed-field-not-error.rs");
    t.compile_fail("tests/ui/transparent-enum-not-error.rs");
    t.compile_fail("tests/ui/transparent-enum-unnamed-field-not-error.rs");
    t.compile_fail("tests/ui/transparent-struct-not-error.rs");
    t.compile_fail("tests/ui/transparent-struct-unnamed-field-not-error.rs");
}
EOF

# Copy the temporary test to the tests directory
cp /tmp/test_source_span_ui.rs tests/test_source_span_ui.rs

# Run the specific UI tests
cargo test --test test_source_span_ui
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
