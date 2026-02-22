#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rustls/tests"
cp "/tests/rustls/tests/api.rs" "rustls/tests/api.rs"

# Clean build artifacts to force recompilation with new test file
cargo clean --package rustls

# Run the specific test file for this PR with quic feature enabled
# The packet_key_api test that uses Side is behind #[cfg(feature = "quic")]
# This will compile the library and tests, which should fail at BASE (with bug.patch applied)
# because the test imports Side which is not public
cargo test --package rustls --test api --features quic 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
