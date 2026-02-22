#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# NOTE: Unlike typical tests, we DO NOT copy the HEAD test file here
# because the bug/fix IS IN the test file itself (pinned vs unpinned nightly).
# The bug.patch has already modified this file to pin the toolchain.
# For Oracle agent, the patch will be reverted, restoring the unpinned version.

# Check if the fix is present (unpinned nightly toolchain)
# The bug.patch pins to "nightly-2025-11-18", the fix uses just "nightly"
if grep -q 'RUSTUP_TOOLCHAIN", "nightly")' "crates/cli/tests/wasm-bindgen/reference.rs" && ! grep -q 'nightly-2025-11-18' "crates/cli/tests/wasm-bindgen/reference.rs"; then
    # The fix is present - uses unpinned nightly
    # Run the test to verify it works with current nightly
    cd crates/cli
    cargo test -p wasm-bindgen-cli reference::runtest_targets_atomics -- --nocapture
    test_status=$?
else
    # The fix is not present - this is the buggy version (pinned to old nightly)
    # Fail the test because using pinned toolchain is the bug
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
