#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_annotations.rs" "testing/tests/test_annotations.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_bytes.rs" "testing/tests/test_bytes.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_de.rs" "testing/tests/test_de.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_macros.rs" "testing/tests/test_macros.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_ser.rs" "testing/tests/test_ser.rs"

# Verify that the fix removes SeqVisitor/MapVisitor and adds the new stateful API
# The key changes are in serde/src/ser/impls.rs and serde/src/ser/mod.rs

# Check that SeqIteratorVisitor is NOT used (it should be removed in the fix)
if grep -q "SeqIteratorVisitor" "serde/src/ser/impls.rs"; then
    echo "FAIL: serde/src/ser/impls.rs should NOT have SeqIteratorVisitor (should be removed)"
    test_status=1
else
    echo "PASS: SeqIteratorVisitor correctly removed from serde/src/ser/impls.rs"
    test_status=0
fi

# Check that serialize_seq_fixed_size is used (not serialize_fixed_size_array)
if [ $test_status -eq 0 ]; then
    if grep -q "serialize_seq_fixed_size" "serde/src/ser/impls.rs"; then
        echo "PASS: serde/src/ser/impls.rs uses serialize_seq_fixed_size"
    else
        echo "FAIL: serde/src/ser/impls.rs should use serialize_seq_fixed_size for arrays"
        test_status=1
    fi
fi

# Check that serialize_fixed_size_array is NOT used (old API)
if [ $test_status -eq 0 ]; then
    if grep -q "serialize_fixed_size_array" "serde/src/ser/impls.rs"; then
        echo "FAIL: serde/src/ser/impls.rs should NOT use serialize_fixed_size_array (old API)"
        test_status=1
    else
        echo "PASS: serialize_fixed_size_array correctly replaced"
    fi
fi

# Check that the serialize_seq! macro exists
if [ $test_status -eq 0 ]; then
    if grep -q "macro_rules! serialize_seq" "serde/src/ser/impls.rs"; then
        echo "PASS: serialize_seq! macro added to serde/src/ser/impls.rs"
    else
        echo "FAIL: serde/src/ser/impls.rs should have serialize_seq! macro"
        test_status=1
    fi
fi

# Check that serialize_seq_end is used (part of new stateful API)
if [ $test_status -eq 0 ]; then
    if grep -q "serialize_seq_end" "serde/src/ser/impls.rs"; then
        echo "PASS: serde/src/ser/impls.rs uses serialize_seq_end (stateful API)"
    else
        echo "FAIL: serde/src/ser/impls.rs should use serialize_seq_end"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
