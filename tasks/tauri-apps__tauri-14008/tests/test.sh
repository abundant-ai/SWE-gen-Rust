#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# The fix adds set_device_event_filter method to the MockRuntimeHandle
# Verify that the mock_runtime.rs file has this method implemented
# We check for the presence of the method in the RuntimeHandle implementation

if grep -q "fn set_device_event_filter(&self, _: DeviceEventFilter)" crates/tauri/src/test/mock_runtime.rs; then
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
