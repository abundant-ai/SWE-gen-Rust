#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"

# Remove the broken tower-hyper dev-dependency to allow tests to compile
sed -i '/tower-hyper/d' tower/Cargo.toml

# The task is to verify reconnect is removed from the facade.
# In the buggy state, `use tower::reconnect` should compile.
# In the fixed state, `use tower::reconnect` should fail to compile.
# We test this by creating a test file that tries to use tower::reconnect.

cat > tower/tests/check_reconnect_removed.rs << 'EOF'
// This test tries to use tower::reconnect, which should exist in buggy state
// but NOT exist in fixed state. If this compiles, the bug is still present.
use tower::reconnect;

#[test]
fn check() {
    // If this compiles, reconnect is still exposed (buggy state)
    let _ = stringify!(reconnect);
}
EOF

# Try to compile the reconnect check test
# This should FAIL in fixed state (reconnect removed) and succeed in buggy state
cargo test --manifest-path tower/Cargo.toml --test check_reconnect_removed --no-run 2>&1 > /tmp/reconnect_check.txt
reconnect_check_status=$?

# Also compile the main builder test to ensure basic functionality works
cargo test --manifest-path tower/Cargo.toml --test builder --no-run 2>&1 > /tmp/builder_check.txt
builder_check_status=$?

# The test passes if:
# - reconnect check FAILS to compile (reconnect is NOT exposed) AND
# - builder test compiles successfully (basic functionality works)
if [ $reconnect_check_status -ne 0 ] && [ $builder_check_status -eq 0 ]; then
    test_status=0  # Success
    echo "PASS: reconnect is not exposed (as expected) and builder compiles"
else
    test_status=1  # Failure
    if [ $reconnect_check_status -eq 0 ]; then
        echo "FAIL: reconnect is still exposed in tower facade"
        cat /tmp/reconnect_check.txt
    fi
    if [ $builder_check_status -ne 0 ]; then
        echo "FAIL: builder test failed to compile"
        cat /tmp/builder_check.txt
    fi
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
