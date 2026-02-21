#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run the specific integration test with 'stream' feature
# The HEAD test file uses #[cfg(feature = "stream")] for some tests
# In the fixed state (HEAD), 'stream' feature exists and tests pass
# In the buggy state (BASE), 'stream' feature was renamed to 'unstable-stream', so this will fail
cargo test --test server --features stream -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
