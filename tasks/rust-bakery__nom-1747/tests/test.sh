#!/bin/bash

cd /app/src

# Set environment variables
export RUST_BACKTRACE=1

# Run specific tests affected by the InputLength trait removal
# These tests use array syntax tag([0x42]) which requires InputLength
# Buggy state (with InputLength): tests compile and pass
# Fixed state (without InputLength): tests fail to compile
cargo test --lib bytes::tests::tag_fixed_size_array --features alloc -- --nocapture
test1_status=$?

cargo test --test issues --features alloc -- --nocapture
test2_status=$?

# Inverted reward: tests passing = buggy (0), tests failing = fixed (1)
if [ $test1_status -eq 0 ] && [ $test2_status -eq 0 ]; then
  echo 0 > /logs/verifier/reward.txt
else
  echo 1 > /logs/verifier/reward.txt
fi

exit 0
