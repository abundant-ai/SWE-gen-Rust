#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_macros/tests"
cp "/tests/serde_macros/tests/skeptic.rs" "serde_macros/tests/skeptic.rs"
cp "/tests/serde_macros/tests/test.rs" "serde_macros/tests/test.rs"

# Verify skeptic.rs exists and has the expected content (key change in fix)
if [ -f "serde_macros/tests/skeptic.rs" ]; then
    if grep -q "skeptic-tests.rs" "serde_macros/tests/skeptic.rs"; then
        echo "PASS: serde_macros/tests/skeptic.rs exists and has skeptic-tests.rs reference"
    else
        echo "FAIL: serde_macros/tests/skeptic.rs exists but missing skeptic-tests.rs reference"
        test_status=1
    fi
else
    echo "FAIL: serde_macros/tests/skeptic.rs does not exist"
    test_status=1
fi

# Verify test.rs no longer has 'mod skeptic;' (removed in bug, added back in fix)
if [ -z "$test_status" ]; then
    if grep -q "mod skeptic;" "serde_macros/tests/test.rs"; then
        echo "PASS: serde_macros/tests/test.rs has 'mod skeptic;' line"
        test_status=0
    else
        echo "FAIL: serde_macros/tests/test.rs should have 'mod skeptic;' line"
        test_status=1
    fi
fi

# Verify Cargo.toml has skeptic test configured (added in fix)
if [ $test_status -eq 0 ]; then
    if grep -A 2 '\[\[test\]\]' "serde_macros/Cargo.toml" | grep -q 'name = "skeptic"'; then
        echo "PASS: Cargo.toml has skeptic test configuration"
    else
        echo "FAIL: Cargo.toml should have skeptic test configuration"
        test_status=1
    fi
fi

# Verify build.rs exists (added back in fix)
if [ $test_status -eq 0 ]; then
    if [ -f "serde_macros/build.rs" ]; then
        if grep -q "skeptic::generate_doc_tests" "serde_macros/build.rs"; then
            echo "PASS: build.rs exists and generates doc tests"
        else
            echo "FAIL: build.rs exists but doesn't generate doc tests"
            test_status=1
        fi
    else
        echo "FAIL: build.rs should exist"
        test_status=1
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
