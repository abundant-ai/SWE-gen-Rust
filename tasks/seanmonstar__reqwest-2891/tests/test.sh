#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"
mkdir -p "tests"
cp "/tests/ci.rs" "tests/ci.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"
mkdir -p "tests"
cp "/tests/connector_layers.rs" "tests/connector_layers.rs"
mkdir -p "tests"
cp "/tests/not_tcp.rs" "tests/not_tcp.rs"
mkdir -p "tests"
cp "/tests/proxy.rs" "tests/proxy.rs"
mkdir -p "tests"
cp "/tests/redirect.rs" "tests/redirect.rs"
mkdir -p "tests"
cp "/tests/retry.rs" "tests/retry.rs"
mkdir -p "tests"
cp "/tests/timeouts.rs" "tests/timeouts.rs"
mkdir -p "tests"
cp "/tests/upgrade.rs" "tests/upgrade.rs"

# Run the specific test files from the PR
cargo test --test badssl \
           --test ci \
           --test client \
           --test connector_layers \
           --test not_tcp \
           --test proxy \
           --test redirect \
           --test retry \
           --test timeouts \
           --test upgrade \
           -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
