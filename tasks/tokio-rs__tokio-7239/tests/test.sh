#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUSTFLAGS="-Dwarnings"
export RUST_BACKTRACE=1

# Copy HEAD test file from /tests (overwrites BASE state)
# Note: queue.rs contains both source code and tests
# bug.patch added the Runtime struct, copying from /tests removes it
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"

# Verify the fix was applied to broadcast.rs (only Oracle does this via fix.patch)
# The BASE state (with bug.patch) incorrectly uses RwLock
# The HEAD state (with fix.patch) correctly uses Mutex
cd tokio
if grep -q "RwLock<Slot<T>>" src/sync/broadcast.rs; then
    echo "ERROR: broadcast.rs still has RwLock - fix.patch not applied"
    test_status=1
else
    echo "SUCCESS: broadcast.rs fixed - using Mutex instead of RwLock"
    # Also run tests to verify functionality
    cargo test --lib runtime::tests::queue --features full
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
