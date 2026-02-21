#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_derive/tests"
cp "/tests/serde_derive/tests/test.rs" "serde_derive/tests/test.rs"

# Verify serde_derive/Cargo.toml exists (was added in the fix)
if [ -f "serde_derive/Cargo.toml" ]; then
    echo "PASS: serde_derive/Cargo.toml exists"
    test_status=0
else
    echo "FAIL: serde_derive/Cargo.toml should exist in fixed state"
    test_status=1
fi

# Verify serde_derive/src/lib.rs exists (was added in the fix)
if [ $test_status -eq 0 ]; then
    if [ -f "serde_derive/src/lib.rs" ]; then
        echo "PASS: serde_derive/src/lib.rs exists"
    else
        echo "FAIL: serde_derive/src/lib.rs should exist in fixed state"
        test_status=1
    fi
fi

# Verify serde_derive/tests/test.rs was restored
if [ $test_status -eq 0 ]; then
    if [ -f "serde_derive/tests/test.rs" ]; then
        echo "PASS: serde_derive/tests/test.rs exists"
    else
        echo "FAIL: serde_derive/tests/test.rs should exist"
        test_status=1
    fi
fi

# Verify the Cargo.toml has the correct content (rustc-macro = true)
if [ $test_status -eq 0 ]; then
    if grep -q "rustc-macro = true" serde_derive/Cargo.toml; then
        echo "PASS: serde_derive/Cargo.toml has rustc-macro = true"
    else
        echo "FAIL: serde_derive/Cargo.toml should have rustc-macro = true"
        test_status=1
    fi
fi

# Verify serde_codegen/src/lib.rs has the syntex_registry function (added in fix)
if [ $test_status -eq 0 ]; then
    if grep -q "fn syntex_registry()" serde_codegen/src/lib.rs; then
        echo "PASS: serde_codegen/src/lib.rs has syntex_registry function"
    else
        echo "FAIL: serde_codegen/src/lib.rs should have syntex_registry function"
        test_status=1
    fi
fi

# Verify serde_codegen/src/lib.rs has expand_str function (added in fix)
if [ $test_status -eq 0 ]; then
    if grep -q "pub fn expand_str" serde_codegen/src/lib.rs; then
        echo "PASS: serde_codegen/src/lib.rs has expand_str function"
    else
        echo "FAIL: serde_codegen/src/lib.rs should have expand_str function"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
