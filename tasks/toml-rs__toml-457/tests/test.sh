#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/datetime.rs" "crates/toml/tests/testsuite/datetime.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/de_errors.rs" "crates/toml/tests/testsuite/de_errors.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/enum_external_deserialize.rs" "crates/toml/tests/testsuite/enum_external_deserialize.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/invalid_misc.rs" "crates/toml/tests/testsuite/invalid_misc.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/main.rs" "crates/toml/tests/testsuite/main.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/parser.rs" "crates/toml/tests/testsuite/parser.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/serde.rs" "crates/toml/tests/testsuite/serde.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/spanned.rs" "crates/toml/tests/testsuite/spanned.rs"

# In Oracle mode, /solution directory is mounted and contains fix.patch
# In NOP mode, /solution directory doesn't exist
# Apply the fix if available (Oracle mode only)
if [ -d "/solution" ] && [ -f "/solution/fix.patch" ]; then
    echo "Oracle mode detected - applying fix.patch..."
    patch -p1 < /solution/fix.patch

    # Rebuild after applying the fix
    cargo build --workspace --all-targets 2>&1 | head -20
fi

# Run the testsuite integration tests for the toml crate
# These tests are in crates/toml/tests/testsuite/ and are compiled into a single test binary
cargo test -p toml --test testsuite -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
