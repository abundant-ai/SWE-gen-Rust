#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tracing-attributes/tests"
cp "/tests/tracing-attributes/tests/follows_from.rs" "tracing-attributes/tests/follows_from.rs"

# Fetch dependencies (in case fix.patch added new ones)
cargo fetch 2>&1

# Clean all build artifacts to force full rebuild
cargo clean 2>&1

# Build and test tracing-attributes
cargo build -p tracing-attributes --tests 2>&1
build_status=$?
if [ $build_status -ne 0 ]; then
    test_status=1
else
    cargo test -p tracing-attributes --tests -- --nocapture
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
