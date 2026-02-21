#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/ui/malformed"
cp "/tests/test_suite/tests/ui/malformed/str_suffix.rs" "test_suite/tests/ui/malformed/str_suffix.rs"
cp "/tests/test_suite/tests/ui/malformed/str_suffix.stderr" "test_suite/tests/ui/malformed/str_suffix.stderr"

# UI compile-fail test: create a test that uses the malformed attributes
# The test file has malformed string literals that should trigger serde_derive errors
cd /app/src/test_suite

# Create a temporary test file within the test_suite to verify the fix
cat > tests/test_str_suffix_check.rs << 'EOF'
use serde::Serialize;

#[derive(Serialize)]
#[serde(bound = ""huh)]
pub struct Struct {
    #[serde(rename = ""what)]
    pub field: i32,
}

#[test]
fn test_compiles() {
    // This test should fail to compile due to malformed string literals
}
EOF

# Try to build the test - it should fail with specific error messages
cargo test --test test_str_suffix_check 2>&1 | tee /tmp/compile_output.txt
compile_exit_code=${PIPESTATUS[0]}

# Clean up temp file
rm -f tests/test_str_suffix_check.rs

# Check if compilation failed (we expect it to fail)
if [ $compile_exit_code -eq 0 ]; then
    echo "ERROR: Compilation succeeded but should have failed!" >&2
    test_status=1
else
    # Compilation failed as expected, now check for the expected error messages
    if grep -q "unexpected suffix.*huh.*on string literal" /tmp/compile_output.txt && \
       grep -q "unexpected suffix.*what.*on string literal" /tmp/compile_output.txt; then
        echo "SUCCESS: Found expected error messages for string literal suffixes"
        test_status=0
    else
        echo "ERROR: Did not find expected error messages" >&2
        echo "Expected to find errors about unexpected suffixes 'huh' and 'what'" >&2
        echo "=== Actual output ==="
        cat /tmp/compile_output.txt
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
