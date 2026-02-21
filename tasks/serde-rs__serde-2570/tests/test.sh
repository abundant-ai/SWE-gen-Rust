#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_remote.rs" "test_suite/tests/test_remote.rs"

# Remove trybuild dependency to avoid compilation issues
sed -i '/trybuild/d; /automod/d; /rustversion/d' test_suite/Cargo.toml
rm -f test_suite/tests/compiletest.rs test_suite/tests/regression.rs

# Run the specific test file
cargo test --test test_remote -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
