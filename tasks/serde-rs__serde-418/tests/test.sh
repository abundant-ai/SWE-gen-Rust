#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_macros/tests"
cp "/tests/serde_macros/tests/compile_tests.rs" "serde_macros/tests/compile_tests.rs"
mkdir -p "serde_macros/tests/run-pass"
cp "/tests/serde_macros/tests/run-pass/identity-op.rs" "serde_macros/tests/run-pass/identity-op.rs"

# Verify that the fix adds the span module and uses it to record expansion info
# The key changes are in serde_codegen/src/span.rs, de.rs, and ser.rs

# Check that span.rs exists (new file added in the fix)
if [ -f "serde_codegen/src/span.rs" ]; then
    echo "PASS: serde_codegen/src/span.rs exists (new file from fix)"
    test_status=0
else
    echo "FAIL: serde_codegen/src/span.rs should exist (added by fix)"
    test_status=1
fi

# Check that span module is used in lib.rs.in
if [ $test_status -eq 0 ]; then
    if grep -q "^mod span;" "serde_codegen/src/lib.rs.in"; then
        echo "PASS: serde_codegen/src/lib.rs.in includes 'mod span;'"
    else
        echo "FAIL: serde_codegen/src/lib.rs.in should include 'mod span;'"
        test_status=1
    fi
fi

# Check that de.rs uses span::record_expansion
if [ $test_status -eq 0 ]; then
    if grep -q "use span;" "serde_codegen/src/de.rs"; then
        echo "PASS: serde_codegen/src/de.rs imports span module"
    else
        echo "FAIL: serde_codegen/src/de.rs should import span module"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
    if grep -q "span::record_expansion" "serde_codegen/src/de.rs"; then
        echo "PASS: serde_codegen/src/de.rs uses span::record_expansion"
    else
        echo "FAIL: serde_codegen/src/de.rs should use span::record_expansion"
        test_status=1
    fi
fi

# Check that ser.rs uses span::record_expansion
if [ $test_status -eq 0 ]; then
    if grep -q "use span;" "serde_codegen/src/ser.rs"; then
        echo "PASS: serde_codegen/src/ser.rs imports span module"
    else
        echo "FAIL: serde_codegen/src/ser.rs should import span module"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
    if grep -q "span::record_expansion" "serde_codegen/src/ser.rs"; then
        echo "PASS: serde_codegen/src/ser.rs uses span::record_expansion"
    else
        echo "FAIL: serde_codegen/src/ser.rs should use span::record_expansion"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
