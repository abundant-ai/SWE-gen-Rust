#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/macros.rs" "serde_tests/tests/macros.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_de.rs" "serde_tests/tests/test_de.rs"
mkdir -p "serde_tests/tests"
cp "/tests/serde_tests/tests/test_ser.rs" "serde_tests/tests/test_ser.rs"

# Verify that the fix adds BuildHasher support to HashMap/HashSet implementations
# The key changes are adding the BuildHasher generic parameter and related code

test_status=0

# Check that BuildHasher IS imported in de/impls.rs (should be added by fix)
if grep -q "use core::hash::{Hash, BuildHasher};" "serde/src/de/impls.rs"; then
    echo "PASS: BuildHasher import added to de/impls.rs"
else
    echo "FAIL: BuildHasher should be imported in de/impls.rs"
    test_status=1
fi

# Check that BuildHasher IS imported in ser/impls.rs (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "use core::hash::{Hash, BuildHasher};" "serde/src/ser/impls.rs"; then
        echo "PASS: BuildHasher import added to ser/impls.rs"
    else
        echo "FAIL: BuildHasher should be imported in ser/impls.rs"
        test_status=1
    fi
fi

# Check that HashMap/HashSet have BuildHasher generic in deserialize impl
if [ $test_status -eq 0 ]; then
    if grep -q "HashSetVisitor<T: Deserialize + Eq + Hash," "serde/src/de/impls.rs"; then
        echo "PASS: HashSet deserialize impl includes BuildHasher support"
    else
        echo "FAIL: HashSet should have visitor signature with BuildHasher"
        test_status=1
    fi
fi

# Check that HashMap uses full signature with BuildHasher
if [ $test_status -eq 0 ]; then
    if grep -q "HashMap<K, V, S>," "serde/src/de/impls.rs"; then
        echo "PASS: HashMap signature includes BuildHasher generic (S)"
    else
        echo "FAIL: HashMap should have full signature with BuildHasher"
        test_status=1
    fi
fi

# Check that test files use FnvHasher (should be added by fix)
if [ $test_status -eq 0 ]; then
    if grep -q "fnv::FnvHasher" "serde_tests/tests/test_de.rs"; then
        echo "PASS: FnvHasher usage added to test_de.rs"
    else
        echo "FAIL: FnvHasher should be present in test_de.rs"
        test_status=1
    fi
fi

# Check that macros.rs has BuildHasherDefault usage
if [ $test_status -eq 0 ]; then
    if grep -q "BuildHasherDefault" "serde_tests/tests/macros.rs"; then
        echo "PASS: BuildHasherDefault added to macros.rs"
    else
        echo "FAIL: BuildHasherDefault should be present in macros.rs"
        test_status=1
    fi
fi

# Verify fnv dependency is added to serde_tests Cargo.toml
if [ $test_status -eq 0 ]; then
    if grep -q "^fnv = " "serde_tests/Cargo.toml"; then
        echo "PASS: fnv dependency added to serde_tests Cargo.toml"
    else
        echo "FAIL: fnv dependency should be present in serde_tests Cargo.toml"
        test_status=1
    fi
fi

# Verify fnv dependency is added to serde_macros Cargo.toml
if [ $test_status -eq 0 ]; then
    if grep -q "^fnv = " "serde_macros/Cargo.toml"; then
        echo "PASS: fnv dependency added to serde_macros Cargo.toml"
    else
        echo "FAIL: fnv dependency should be present in serde_macros Cargo.toml"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
