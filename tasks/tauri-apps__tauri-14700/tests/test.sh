#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# The bug removes BSD support from the Runtime trait and implementations
# When the fix is applied, it adds BSD support back to all affected files
# This test verifies that BSD platforms are properly included in cfg attributes

# Check that the Runtime trait includes BSD support in new_any_thread()
# The fix should add dragonfly, freebsd, netbsd, and openbsd to the cfg attribute
# We need to check BEFORE the function declaration for the #[cfg(...)] attribute
if grep -B 20 "fn new_any_thread" crates/tauri-runtime/src/lib.rs | grep -q "target_os = \"freebsd\""; then
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
