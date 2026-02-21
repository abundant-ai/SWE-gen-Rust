#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/integration.rs" "tests/integration.rs"
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run specific tests that were added/modified by the PR
# Note: We run specific tests by name to avoid unrelated test failures
cargo test --test integration -- post_outgoing_length --exact --nocapture && \
cargo test --test integration -- post_chunked --exact --nocapture && \
cargo test --test server -- response_body_lengths::http2_auto_response_with_known_length --exact --nocapture && \
cargo test --test server -- response_body_lengths::http2_auto_response_with_conflicting_lengths --exact --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
