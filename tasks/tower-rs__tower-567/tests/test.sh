#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests/buffer"
cp "/tests/tower/tests/buffer/main.rs" "tower/tests/buffer/main.rs"
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"

# Run the specific integration tests
cargo test --test buffer --all-features -- --nocapture
buffer_status=$?

cargo test --test builder --all-features -- --nocapture
builder_status=$?

# Exit with failure if either test failed
if [ $buffer_status -eq 0 ] && [ $builder_status -eq 0 ]; then
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
