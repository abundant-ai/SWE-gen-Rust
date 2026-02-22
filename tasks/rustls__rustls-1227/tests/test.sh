#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
# No test files to copy

# This PR makes ClientSessionValue private
# The buggy state has persist_test module declared in mod.rs (which should not be there)
# Check if the module is declared - it should NOT be in the fixed state
if grep -q "persist_test" rustls/src/msgs/mod.rs; then
    echo "FAIL: persist_test module is declared in mod.rs (buggy state)" >&2
    test_status=1
else
    echo "PASS: persist_test module is not declared (fixed state)" >&2
    # Also verify basic tests pass
    cargo test --package rustls --lib -- --nocapture 2>&1
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
