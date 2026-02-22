#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/serde.rs" "crates/toml_edit/tests/testsuite/serde.rs"

# In Oracle mode, /solution directory is mounted and contains fix.patch
# In NOP mode, /solution directory doesn't exist
# Apply the fix if available (Oracle mode only)
if [ -d "/solution" ] && [ -f "/solution/fix.patch" ]; then
    echo "Oracle mode detected - applying fix.patch..."
    patch -p1 < /solution/fix.patch
fi

# Rebuild after copying test files and/or applying fix
# This ensures the test binary includes the updated tests and implementation
cargo build --workspace --all-targets 2>&1 | head -20

# Run the testsuite integration tests for the toml_edit crate with the "easy" feature enabled
# These tests are in crates/toml_edit/tests/testsuite/ and are compiled into a single test binary
# The "easy" feature is required for enum_external_deserialize and serde tests
cargo test -p toml_edit --test testsuite --features easy -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
