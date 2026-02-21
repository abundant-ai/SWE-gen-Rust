#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_bytes.rs" "testing/tests/test_bytes.rs"

# Verify that the fix splits serialize_map_elt into separate key/value methods
# The key changes are in the Serializer trait (serde/src/ser/mod.rs) and its implementations

# Check that serde/src/ser/mod.rs has separate serialize_map_key and serialize_map_value methods (added in fix)
if grep -q "fn serialize_map_key" "serde/src/ser/mod.rs"; then
    if grep -q "fn serialize_map_value" "serde/src/ser/mod.rs"; then
        echo "PASS: serde/src/ser/mod.rs has both serialize_map_key and serialize_map_value methods"
        test_status=0
    else
        echo "FAIL: serde/src/ser/mod.rs has serialize_map_key but missing serialize_map_value"
        test_status=1
    fi
else
    echo "FAIL: serde/src/ser/mod.rs should have serialize_map_key method"
    test_status=1
fi

# Verify that serialize_map_elt was removed from trait definition (it existed in bug state)
if [ $test_status -eq 0 ]; then
    if grep -q "fn serialize_map_elt" "serde/src/ser/mod.rs"; then
        echo "FAIL: serde/src/ser/mod.rs should NOT have serialize_map_elt method (should be split)"
        test_status=1
    else
        echo "PASS: serialize_map_elt method correctly removed from serde/src/ser/mod.rs"
    fi
fi

# Verify that serde/src/ser/impls.rs uses the separate key/value calls (not serialize_map_elt)
if [ $test_status -eq 0 ]; then
    if grep -q "serialize_map_key" "serde/src/ser/impls.rs" && grep -q "serialize_map_value" "serde/src/ser/impls.rs"; then
        echo "PASS: serde/src/ser/impls.rs uses separate serialize_map_key and serialize_map_value calls"
    else
        echo "FAIL: serde/src/ser/impls.rs should call serialize_map_key and serialize_map_value"
        test_status=1
    fi
fi

# Verify serde_test/src/ser.rs implementation has the split methods
if [ $test_status -eq 0 ]; then
    if grep -q "fn serialize_map_key" "serde_test/src/ser.rs" && grep -q "fn serialize_map_value" "serde_test/src/ser.rs"; then
        echo "PASS: serde_test/src/ser.rs implements both serialize_map_key and serialize_map_value"
    else
        echo "FAIL: serde_test/src/ser.rs should implement serialize_map_key and serialize_map_value"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
