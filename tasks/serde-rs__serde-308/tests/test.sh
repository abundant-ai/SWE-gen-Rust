#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test.rs.in" "serde_tests/tests/test.rs.in"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_de.rs" "serde_tests/tests/test_de.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_gen.rs" "serde_tests/tests/test_gen.rs"

# Verify that the fix properly handles deserialize_with with generics
# The fix changes deserialize_with from P<ast::Expr> to Option<ast::Path> in attr.rs
# It also modifies wrap_deserialize_with and moves it from attr.rs to de.rs

test_status=0

# Check that deserialize_with field in FieldAttrs is Option<ast::Path> (changed by fix)
if grep -q "deserialize_with: Option<ast::Path>" "serde_codegen/src/attr.rs"; then
    echo "PASS: deserialize_with field is Option<ast::Path>"
else
    echo "FAIL: deserialize_with should be Option<ast::Path> in FieldAttrs"
    test_status=1
fi

# Check that wrap_deserialize_with function is NOT in attr.rs (removed by fix)
if [ $test_status -eq 0 ]; then
    if ! grep -q "^fn wrap_deserialize_with(" "serde_codegen/src/attr.rs"; then
        echo "PASS: wrap_deserialize_with removed from attr.rs"
    else
        echo "FAIL: wrap_deserialize_with should not be in attr.rs"
        test_status=1
    fi
fi

# Check that wrap_deserialize_with function EXISTS in de.rs (moved there by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "^fn wrap_deserialize_with(" "serde_codegen/src/de.rs"; then
        echo "PASS: wrap_deserialize_with function exists in de.rs"
    else
        echo "FAIL: wrap_deserialize_with should exist in de.rs"
        test_status=1
    fi
fi

# Check that deserialize_struct_as_seq signature has type_ident parameter (added by fix)
if [ $test_status -eq 0 ]; then
    if grep -A 5 "fn deserialize_struct_as_seq" "serde_codegen/src/de.rs" | grep -q "type_ident: Ident"; then
        echo "PASS: deserialize_struct_as_seq has type_ident parameter"
    else
        echo "FAIL: deserialize_struct_as_seq should have type_ident parameter"
        test_status=1
    fi
fi

# Check that deserialize_struct_as_seq signature has impl_generics parameter (added by fix)
if [ $test_status -eq 0 ]; then
    if grep -A 6 "fn deserialize_struct_as_seq" "serde_codegen/src/de.rs" | grep -q "impl_generics: &ast::Generics"; then
        echo "PASS: deserialize_struct_as_seq has impl_generics parameter"
    else
        echo "FAIL: deserialize_struct_as_seq should have impl_generics parameter"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
