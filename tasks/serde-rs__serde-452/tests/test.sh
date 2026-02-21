#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_macros/tests"
cp "/tests/serde_macros/tests/test.rs" "serde_macros/tests/test.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test.rs.in" "testing/tests/test.rs.in"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_bytes.rs" "testing/tests/test_bytes.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_de.rs" "testing/tests/test_de.rs"

# Verify that the fix adds the de_forward_to_deserialize macro and uses deserialize_seq_fixed_size
# The key changes are in serde/src/de/mod.rs and serde/src/de/impls.rs

# Check that serde/src/de/mod.rs has the de_forward_to_deserialize macro (added in fix)
if grep -q "macro_rules! de_forward_to_deserialize" "serde/src/de/mod.rs"; then
    echo "PASS: serde/src/de/mod.rs has de_forward_to_deserialize macro"
    test_status=0
else
    echo "FAIL: serde/src/de/mod.rs should have de_forward_to_deserialize macro"
    test_status=1
fi

# Verify that serde/src/de/impls.rs uses deserialize_seq_fixed_size (not deserialize_fixed_size_array)
if [ $test_status -eq 0 ]; then
    if grep -q "deserialize_seq_fixed_size" "serde/src/de/impls.rs"; then
        echo "PASS: serde/src/de/impls.rs uses deserialize_seq_fixed_size"
    else
        echo "FAIL: serde/src/de/impls.rs should call deserialize_seq_fixed_size (not deserialize_fixed_size_array)"
        test_status=1
    fi
fi

# Verify that deserialize_fixed_size_array is NOT used in impls.rs (it existed in bug state)
if [ $test_status -eq 0 ]; then
    if grep -q "deserialize_fixed_size_array" "serde/src/de/impls.rs"; then
        echo "FAIL: serde/src/de/impls.rs should NOT use deserialize_fixed_size_array method"
        test_status=1
    else
        echo "PASS: deserialize_fixed_size_array correctly replaced with deserialize_seq_fixed_size"
    fi
fi

# Verify that the de_forward_to_deserialize macro has the deserialize_seq_fixed_size case
if [ $test_status -eq 0 ]; then
    if grep -q "deserialize_seq_fixed_size" "serde/src/de/mod.rs"; then
        echo "PASS: serde/src/de/mod.rs de_forward_to_deserialize includes deserialize_seq_fixed_size"
    else
        echo "FAIL: serde/src/de/mod.rs should include deserialize_seq_fixed_size in the macro"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
