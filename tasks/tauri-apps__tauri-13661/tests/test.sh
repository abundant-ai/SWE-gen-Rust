#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# The fix adds set_cookie and delete_cookie methods to the WebviewDispatch trait
# Verify that the trait definition includes these methods
if grep -q "fn set_cookie" crates/tauri-runtime/src/lib.rs && \
   grep -q "fn delete_cookie" crates/tauri-runtime/src/lib.rs; then
    echo "SUCCESS: set_cookie and delete_cookie methods are in WebviewDispatch trait"
    test_status=0
else
    echo "FAIL: set_cookie and delete_cookie methods are missing from WebviewDispatch trait"
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
