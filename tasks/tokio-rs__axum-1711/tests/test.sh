#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Rebuild axum to pick up any changes from fix.patch
cargo build -p axum 2>&1 | head -20 || true

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/fallback.rs" "axum/src/routing/tests/fallback.rs"
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/mod.rs" "axum/src/routing/tests/mod.rs"
mkdir -p "axum/src/routing/tests"
cp "/tests/axum/src/routing/tests/nest.rs" "axum/src/routing/tests/nest.rs"

# Run tests in the routing module (covers fallback, nest, and mod.rs tests)
# We need to verify that at least 1 test actually ran
test_output=$(cargo test -p axum --lib routing::tests:: -- --test-threads=1 2>&1)
test_status=$?
echo "$test_output"

# Check if at least one test ran (look for "test result:" not "0 passed")
if echo "$test_output" | grep -q "0 passed"; then
    echo "ERROR: No tests ran - routing tests don't exist"
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
