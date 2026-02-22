#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# The fix adds go_back, can_go_back, go_forward, and can_go_forward methods to the mock runtime
# Verify that the mock_runtime.rs file has these navigation methods implemented
# We check for the presence of all four methods in the WebviewDispatch implementation

methods_found=0

if grep -q "fn go_back(&self) -> Result<()>" crates/tauri/src/test/mock_runtime.rs; then
    methods_found=$((methods_found + 1))
fi

if grep -q "fn can_go_back(&self) -> Result<bool>" crates/tauri/src/test/mock_runtime.rs; then
    methods_found=$((methods_found + 1))
fi

if grep -q "fn go_forward(&self) -> Result<()>" crates/tauri/src/test/mock_runtime.rs; then
    methods_found=$((methods_found + 1))
fi

if grep -q "fn can_go_forward(&self) -> Result<bool>" crates/tauri/src/test/mock_runtime.rs; then
    methods_found=$((methods_found + 1))
fi

# All four methods should be present
if [ $methods_found -eq 4 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
