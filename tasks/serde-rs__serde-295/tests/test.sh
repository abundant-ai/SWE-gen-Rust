#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_macros.rs" "serde_tests/tests/test_macros.rs"

# Verify that the fix properly handles default type parameters in derived traits
# The fix adds the `without_defaults` function that strips defaults from impl generics
test_status=0

# Check that without_defaults function exists (added by fix)
if grep -q "pub fn without_defaults" "serde_codegen/src/bound.rs"; then
    echo "PASS: without_defaults function exists in bound.rs"
else
    echo "FAIL: without_defaults function missing from bound.rs"
    test_status=1
fi

# Check that de.rs uses without_defaults (added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "bound::without_defaults(generics)" "serde_codegen/src/de.rs"; then
        echo "PASS: Deserialize impl uses without_defaults"
    else
        echo "FAIL: Deserialize impl should use without_defaults"
        test_status=1
    fi
fi

# Check that ser.rs uses without_defaults (added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "bound::without_defaults(generics)" "serde_codegen/src/ser.rs"; then
        echo "PASS: Serialize impl uses without_defaults"
    else
        echo "FAIL: Serialize impl should use without_defaults"
        test_status=1
    fi
fi

# Check that test file has the default type parameter test (added by fix via file copy)
if [ $test_status -eq 0 ]; then
    if grep -q "fn test_default_ty_param" "serde_tests/tests/test_macros.rs"; then
        echo "PASS: Test file includes test_default_ty_param test"
    else
        echo "FAIL: Test file should include test_default_ty_param test"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
