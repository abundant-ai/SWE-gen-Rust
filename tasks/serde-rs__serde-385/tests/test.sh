#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_macros/tests/compile-fail"
cp "/tests/serde_macros/tests/compile-fail/duplicate_attributes.rs" "serde_macros/tests/compile-fail/duplicate_attributes.rs"

# Verify that the fix adds duplicate attribute detection in serde_codegen/src/attr.rs
# The key change is adding the Attr and BoolAttr structs that track attribute usage

# Check that the Attr struct exists with duplicate detection
if grep -q "struct Attr<'a, 'b: 'a, T>" "serde_codegen/src/attr.rs"; then
    echo "PASS: Attr struct exists"
    test_status=0
else
    echo "FAIL: Attr struct should exist (added by fix)"
    test_status=1
fi

# Check that the Attr::set method includes duplicate detection
if [ $test_status -eq 0 ]; then
    if grep -q "duplicate serde attribute" "serde_codegen/src/attr.rs"; then
        echo "PASS: Duplicate attribute detection exists"
    else
        echo "FAIL: Should detect duplicate serde attributes"
        test_status=1
    fi
fi

# Check that BoolAttr struct exists
if [ $test_status -eq 0 ]; then
    if grep -q "struct BoolAttr" "serde_codegen/src/attr.rs"; then
        echo "PASS: BoolAttr struct exists"
    else
        echo "FAIL: BoolAttr struct should exist (added by fix)"
        test_status=1
    fi
fi

# Check that the set method validates for duplicates using Spanned
if [ $test_status -eq 0 ]; then
    if grep -q "if let Some(Spanned { span: prev_span, .. }) = self.value" "serde_codegen/src/attr.rs"; then
        echo "PASS: Attr::set method checks for duplicates"
    else
        echo "FAIL: Attr::set method should check for duplicates"
        test_status=1
    fi
fi

# Verify the duplicate_attributes test file is present
if [ $test_status -eq 0 ]; then
    if [ -f "serde_macros/tests/compile-fail/duplicate_attributes.rs" ]; then
        echo "PASS: duplicate_attributes.rs test file exists"
    else
        echo "FAIL: duplicate_attributes.rs test file should exist"
        test_status=1
    fi
fi

# Check that the test file contains expected duplicate attribute tests
if [ $test_status -eq 0 ]; then
    if grep -q "//~ ERROR: duplicate serde attribute" "serde_macros/tests/compile-fail/duplicate_attributes.rs"; then
        echo "PASS: Test file contains duplicate attribute tests"
    else
        echo "FAIL: Test file should contain duplicate attribute tests"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
