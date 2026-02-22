#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test.rs" "serde_tests/tests/test.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_annotations.rs" "serde_tests/tests/test_annotations.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_bytes.rs" "serde_tests/tests/test_bytes.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_de.rs" "serde_tests/tests/test_de.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/token.rs" "serde_tests/tests/token.rs"

# Verify that the fix properly handles extern crate serde in non-toplevel modules
# The fix introduces `extern crate serde as _serde;` in generated code and changes
# all ::serde references to _serde references

test_status=0

# Check that Deserialize impl uses _serde alias (introduced by fix)
if grep -q "extern crate serde as _serde" "serde_codegen/src/de.rs"; then
    echo "PASS: Deserialize impl uses _serde alias"
else
    echo "FAIL: Deserialize impl should use 'extern crate serde as _serde'"
    test_status=1
fi

# Check that Serialize impl uses _serde alias (introduced by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "extern crate serde as _serde" "serde_codegen/src/ser.rs"; then
        echo "PASS: Serialize impl uses _serde alias"
    else
        echo "FAIL: Serialize impl should use 'extern crate serde as _serde'"
        test_status=1
    fi
fi

# Check that serialize_with uses _serde (changed by fix from ::serde)
if [ $test_status -eq 0 ]; then
    if grep -q "_serde::ser::Serializer" "serde_codegen/src/attr.rs"; then
        echo "PASS: serialize_with uses _serde::ser::Serializer"
    else
        echo "FAIL: serialize_with should use _serde::ser::Serializer"
        test_status=1
    fi
fi

# Check that deserialize_with uses _serde (changed by fix from ::serde)
if [ $test_status -eq 0 ]; then
    if grep -q "_serde::de::Deserialize" "serde_codegen/src/attr.rs"; then
        echo "PASS: deserialize_with uses _serde::de::Deserialize"
    else
        echo "FAIL: deserialize_with should use _serde::de::Deserialize"
        test_status=1
    fi
fi

# Check that bound.rs uses global path for trait bound (changed by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "bound: &ast::Path" "serde_codegen/src/bound.rs"; then
        echo "PASS: bound.rs uses &ast::Path for bound parameter"
    else
        echo "FAIL: bound.rs should use &ast::Path for bound parameter"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
