#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-buffer/tests"
cp "/tests/tower-buffer/tests/buffer.rs" "tower-buffer/tests/buffer.rs"

# Run the specific test that validates the fix
# The when_spawn_fails test verifies that Buffer::new is infallible and spawn errors surface in poll_ready
cargo test --manifest-path tower-buffer/Cargo.toml --test buffer when_spawn_fails -- --nocapture --test-threads=1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
