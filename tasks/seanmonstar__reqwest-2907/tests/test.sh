#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/badssl.rs" "tests/badssl.rs"
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# The bug is that native-tls doesn't properly enable __native-tls internal feature.
# This means tests requiring __native-tls won't be compiled when native-tls is enabled.
# We need to verify that test_badssl_wrong_host runs (it requires __native-tls).

# First, run all tests with native-tls feature
cargo test --test badssl --test client --features native-tls -- --nocapture > /tmp/test_output.txt 2>&1
test_exit_code=$?

# Check if test_badssl_wrong_host ran (it should only run if __native-tls is properly enabled)
if grep -q "test_badssl_wrong_host" /tmp/test_output.txt; then
    # Test was found and ran - this is correct (fixed state)
    test_status=0
else
    # Test was not found - this indicates __native-tls wasn't enabled (buggy state)
    echo "FAILED: test_badssl_wrong_host did not run - __native-tls not properly enabled by native-tls feature" >&2
    test_status=1
fi

# Also check if the test itself passed
if [ $test_exit_code -ne 0 ]; then
    echo "FAILED: Tests failed with exit code $test_exit_code" >&2
    test_status=1
fi

cat /tmp/test_output.txt

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
