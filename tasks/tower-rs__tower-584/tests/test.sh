#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"
mkdir -p "tower/tests/retry"
cp "/tests/tower/tests/retry/main.rs" "tower/tests/retry/main.rs"

# Run the specific integration tests
cargo test --test builder --all-features -- --nocapture
builder_status=$?

cargo test --test retry --all-features -- --nocapture
retry_status=$?

# Exit with failure if either test failed
if [ $builder_status -eq 0 ] && [ $retry_status -eq 0 ]; then
  test_status=0
else
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
