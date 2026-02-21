#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/rename-and-ser.rs" "serde_derive/tests/compile-fail/duplicate-attribute/rename-and-ser.rs"
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/rename-rename-de.rs" "serde_derive/tests/compile-fail/duplicate-attribute/rename-rename-de.rs"
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-rename-ser.rs" "serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-rename-ser.rs"
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-rename.rs" "serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-rename.rs"
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-ser.rs" "serde_derive/tests/compile-fail/duplicate-attribute/rename-ser-ser.rs"
mkdir -p "serde_derive/tests/compile-fail/duplicate-attribute"
cp "/tests/serde_derive/tests/compile-fail/duplicate-attribute/two-rename-ser.rs" "serde_derive/tests/compile-fail/duplicate-attribute/two-rename-ser.rs"
mkdir -p "serde_derive/tests/compile-fail"
cp "/tests/serde_derive/tests/compile-fail/str_ref_deser.rs" "serde_derive/tests/compile-fail/str_ref_deser.rs"
mkdir -p "serde_derive/tests/compile-fail/unknown-attribute"
cp "/tests/serde_derive/tests/compile-fail/unknown-attribute/container.rs" "serde_derive/tests/compile-fail/unknown-attribute/container.rs"
mkdir -p "serde_derive/tests/compile-fail/unknown-attribute"
cp "/tests/serde_derive/tests/compile-fail/unknown-attribute/field.rs" "serde_derive/tests/compile-fail/unknown-attribute/field.rs"
mkdir -p "serde_derive/tests/compile-fail/unknown-attribute"
cp "/tests/serde_derive/tests/compile-fail/unknown-attribute/variant.rs" "serde_derive/tests/compile-fail/unknown-attribute/variant.rs"
mkdir -p "serde_derive/tests"
cp "/tests/serde_derive/tests/compile_tests.rs" "serde_derive/tests/compile_tests.rs"
mkdir -p "serde_derive/tests/run-pass"
cp "/tests/serde_derive/tests/run-pass/identity-op.rs" "serde_derive/tests/run-pass/identity-op.rs"
mkdir -p "serde_derive/tests"
cp "/tests/serde_derive/tests/test.rs" "serde_derive/tests/test.rs"

# Verify serde_macros/Cargo.toml does NOT exist (was deleted in the fix)
if [ -f "serde_macros/Cargo.toml" ]; then
    echo "FAIL: serde_macros/Cargo.toml should not exist in fixed state"
    test_status=1
else
    echo "PASS: serde_macros/Cargo.toml correctly deleted"
    test_status=0
fi

# Verify serde_macros/src/lib.rs does NOT exist (was deleted in the fix)
if [ $test_status -eq 0 ]; then
    if [ -f "serde_macros/src/lib.rs" ]; then
        echo "FAIL: serde_macros/src/lib.rs should not exist in fixed state"
        test_status=1
    else
        echo "PASS: serde_macros/src/lib.rs correctly deleted"
    fi
fi

# Verify serde_derive has compiletest_rs dependency
if [ $test_status -eq 0 ]; then
    if grep -q "compiletest_rs" serde_derive/Cargo.toml; then
        echo "PASS: serde_derive/Cargo.toml has compiletest_rs dependency"
    else
        echo "FAIL: serde_derive/Cargo.toml missing compiletest_rs dependency"
        test_status=1
    fi
fi

# Verify compile_tests.rs exists in serde_derive
if [ $test_status -eq 0 ]; then
    if [ -f "serde_derive/tests/compile_tests.rs" ]; then
        echo "PASS: serde_derive/tests/compile_tests.rs exists"
    else
        echo "FAIL: serde_derive/tests/compile_tests.rs missing"
        test_status=1
    fi
fi

# Verify test.rs includes compile_tests module
if [ $test_status -eq 0 ]; then
    if grep -q "mod compile_tests" serde_derive/tests/test.rs; then
        echo "PASS: serde_derive/tests/test.rs includes compile_tests module"
    else
        echo "FAIL: serde_derive/tests/test.rs doesn't include compile_tests module"
        test_status=1
    fi
fi

# Verify the compile-fail test files exist in serde_derive
if [ $test_status -eq 0 ]; then
    test_files=(
        "serde_derive/tests/compile-fail/duplicate-attribute/rename-and-ser.rs"
        "serde_derive/tests/compile-fail/duplicate-attribute/rename-rename-de.rs"
        "serde_derive/tests/compile-fail/unknown-attribute/container.rs"
    )
    for test_file in "${test_files[@]}"; do
        if [ ! -f "$test_file" ]; then
            echo "FAIL: $test_file missing"
            test_status=1
            break
        fi
    done
    if [ $test_status -eq 0 ]; then
        echo "PASS: All compile-fail test files exist in serde_derive"
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
