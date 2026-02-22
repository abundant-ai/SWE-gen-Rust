#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/ide-db/src/imports/insert_use"
cp "/tests/crates/ide-db/src/imports/insert_use/tests.rs" "crates/ide-db/src/imports/insert_use/tests.rs"

# Run tests in the insert_use module
# The test file is part of the ide-db crate's imports/insert_use tests module
cargo test -p ide-db --lib insert_use -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
