#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_gen.rs" "serde_tests/tests/test_gen.rs"

# Verify that the fix adds the bound attribute support to serde_codegen
# The key changes are in serde_codegen/src/attr.rs, bound.rs, de.rs, and ser.rs
# PR #352 ADDS bound attribute support, so we check that it EXISTS after fix

test_status=0

# Check that bound-related imports ARE in attr.rs (should be added by fix)
if grep -q "use syntax::parse::parser::{Parser, PathStyle}" "serde_codegen/src/attr.rs"; then
    echo "PASS: Parser import added to attr.rs"
else
    echo "FAIL: Parser import should be present in attr.rs"
    test_status=1
fi

# Check that ser_bound field IS in ContainerAttrs (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "ser_bound: Option<Vec<ast::WherePredicate>>" "serde_codegen/src/attr.rs"; then
        echo "PASS: ser_bound field added to ContainerAttrs"
    else
        echo "FAIL: ser_bound field should be present in ContainerAttrs"
        test_status=1
    fi
fi

# Check that de_bound field IS in ContainerAttrs (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "de_bound: Option<Vec<ast::WherePredicate>>" "serde_codegen/src/attr.rs"; then
        echo "PASS: de_bound field added to ContainerAttrs"
    else
        echo "FAIL: de_bound field should be present in ContainerAttrs"
        test_status=1
    fi
fi

# Check that get_where_predicates function IS present (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "fn get_where_predicates" "serde_codegen/src/attr.rs"; then
        echo "PASS: get_where_predicates function added"
    else
        echo "FAIL: get_where_predicates function should be present"
        test_status=1
    fi
fi

# Check that parse_lit_into_where function IS present (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "fn parse_lit_into_where" "serde_codegen/src/attr.rs"; then
        echo "PASS: parse_lit_into_where function added"
    else
        echo "FAIL: parse_lit_into_where function should be present"
        test_status=1
    fi
fi

# Check that with_where_predicates IS in bound.rs (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "pub fn with_where_predicates" "serde_codegen/src/bound.rs"; then
        echo "PASS: with_where_predicates added to bound.rs"
    else
        echo "FAIL: with_where_predicates should be present in bound.rs"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
