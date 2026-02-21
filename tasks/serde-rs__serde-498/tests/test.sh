#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "serde_macros/tests/run-pass"
cp "/tests/serde_macros/tests/run-pass/identity-op.rs" "serde_macros/tests/run-pass/identity-op.rs"

# Verify serde_macros/Cargo.toml does NOT have clippy in unstable-testing features (key change in fix)
if grep -A 5 'unstable-testing = \[' serde_macros/Cargo.toml | grep -q '"clippy"'; then
    echo "FAIL: serde_macros/Cargo.toml should NOT have clippy in unstable-testing features"
    test_status=1
else
    echo "PASS: serde_macros/Cargo.toml does not have clippy in unstable-testing features"
    test_status=0
fi

# Also verify serde/Cargo.toml does NOT have clippy
if [ $test_status -eq 0 ]; then
    if grep -q 'unstable-testing = \["clippy"' serde/Cargo.toml; then
        echo "FAIL: serde/Cargo.toml should NOT have clippy in unstable-testing"
        test_status=1
    else
        echo "PASS: serde/Cargo.toml does not have clippy in unstable-testing"
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
