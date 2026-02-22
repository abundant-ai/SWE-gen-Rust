#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/support"
cp "/tests/support/server.rs" "tests/support/server.rs"

# The PR makes Rustls the default TLS provider instead of native-tls.
# Test use_preconfigured_rustls_default requires __rustls feature.
# With default features:
#   Fixed state: __rustls enabled (via rustls-tls) - test exists and runs  
#   Buggy state: __rustls NOT enabled (uses native-tls) - test filtered out

# Run the test (it's in tests/client.rs, so use --test client)
cargo test --test client use_preconfigured_rustls_default -- --exact 2>&1 | tee /tmp/test_out.txt

# Check if at least one test passed
if grep -q "test result: ok. 1 passed" /tmp/test_out.txt; then
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
