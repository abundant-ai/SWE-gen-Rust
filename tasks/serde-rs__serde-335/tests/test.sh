#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_gen.rs" "serde_tests/tests/test_gen.rs"

# Verify that the fix REMOVES the wrapper functions and reverts to simple Path types
# PR #335 REVERTS changes that incorrectly wrapped serialize_with/deserialize_with
# The buggy state has wrapper functions, the fixed state does not

test_status=0

# Check that serialize_with field is Option<ast::Path> (should be reverted by fix)
if grep -q "serialize_with: Option<ast::Path>" "serde_codegen/src/attr.rs"; then
    echo "PASS: serialize_with is Option<ast::Path> (wrapper removed)"
else
    echo "FAIL: serialize_with should be Option<ast::Path>, not Option<P<ast::Expr>>"
    test_status=1
fi

# Check that skip_serializing_if field is Option<ast::Path> (should be reverted by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "skip_serializing_if: Option<ast::Path>" "serde_codegen/src/attr.rs"; then
        echo "PASS: skip_serializing_if is Option<ast::Path> (wrapper removed)"
    else
        echo "FAIL: skip_serializing_if should be Option<ast::Path>, not Option<P<ast::Expr>>"
        test_status=1
    fi
fi

# Check that from_field signature does NOT have container_ty/generics/is_enum params (should be reverted)
if [ $test_status -eq 0 ]; then
    if ! grep -q "container_ty: &P<ast::Ty>" "serde_codegen/src/attr.rs"; then
        echo "PASS: from_field signature reverted (no container_ty param)"
    else
        echo "FAIL: from_field should not have container_ty parameter"
        test_status=1
    fi
fi

# Check that wrap_serialize_with function is NOT present (should be removed by fix)
if [ $test_status -eq 0 ]; then
    if ! grep -q "fn wrap_serialize_with" "serde_codegen/src/attr.rs"; then
        echo "PASS: wrap_serialize_with function removed"
    else
        echo "FAIL: wrap_serialize_with function should not exist"
        test_status=1
    fi
fi

# Check that the simple parse_lit_into_path assignment is present (not wrapped)
if [ $test_status -eq 0 ]; then
    if grep -q "field_attrs.serialize_with = Some(path);" "serde_codegen/src/attr.rs"; then
        echo "PASS: serialize_with assignment is simple (not wrapped)"
    else
        echo "FAIL: serialize_with should be assigned directly from path"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
