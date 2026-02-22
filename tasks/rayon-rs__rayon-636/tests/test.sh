#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "rayon-core/tests"
cp "/tests/rayon-core/tests/scoped_threadpool.rs" "rayon-core/tests/scoped_threadpool.rs"

# Run the specific test files
cargo test -p rayon-core --test scoped_threadpool -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
