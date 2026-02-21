#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/server.rs" "tests/server.rs"

# Run specific test that was added by the PR with timeout (test can hang when bug is present)
# Use 300s timeout to allow for compilation + test execution
timeout 300 cargo test --test server -- try_h2 --exact --nocapture
test_status=$?

# timeout returns 124 if the command times out, treat this as a test failure
if [ $test_status -eq 124 ]; then
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
