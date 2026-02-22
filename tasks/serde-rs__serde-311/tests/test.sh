#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_annotations.rs" "serde_tests/tests/test_annotations.rs"

# Verify that the fix properly handles deserialize_with fields
# The fix REMOVES the expr_is_missing method from FieldAttrs and moves logic to de.rs
# It also adds back default_expr_if_missing accessor and removes the TODO comment

test_status=0

# Check that expr_is_missing is NOT a method on FieldAttrs (should be removed by fix)
if ! grep -q "pub fn expr_is_missing(&self) -> P<ast::Expr>" "serde_codegen/src/attr.rs"; then
    echo "PASS: expr_is_missing method removed from FieldAttrs"
else
    echo "FAIL: expr_is_missing should not be a method in FieldAttrs"
    test_status=1
fi

# Check that the standalone expr_is_missing function EXISTS in de.rs (added back by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "^fn expr_is_missing(" "serde_codegen/src/de.rs"; then
        echo "PASS: standalone expr_is_missing function exists in de.rs"
    else
        echo "FAIL: standalone expr_is_missing function should exist in de.rs"
        test_status=1
    fi
fi

# Check that calls use expr_is_missing(cx, attrs) instead of attrs.expr_is_missing()
if [ $test_status -eq 0 ]; then
    if grep -q "expr_is_missing(cx, attrs)" "serde_codegen/src/de.rs"; then
        echo "PASS: de.rs uses expr_is_missing(cx, attrs)"
    else
        echo "FAIL: de.rs should call expr_is_missing(cx, attrs)"
        test_status=1
    fi
fi

# Check that the TODO comment about requiring T: Deserialize is REMOVED (by the fix)
if [ $test_status -eq 0 ]; then
    if ! grep -q "TODO: For now we require" "serde_codegen/src/de.rs"; then
        echo "PASS: TODO comment about T: Deserialize removed"
    else
        echo "FAIL: TODO comment should be removed"
        test_status=1
    fi
fi

# Check that default_expr_if_missing accessor EXISTS in attr.rs (added back by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "pub fn default_expr_if_missing(&self) -> Option<&P<ast::Expr>>" "serde_codegen/src/attr.rs"; then
        echo "PASS: default_expr_if_missing accessor present"
    else
        echo "FAIL: default_expr_if_missing accessor should be present"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
