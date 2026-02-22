#!/bin/bash

cd /app/src

# Copy HEAD template files from /tests
mkdir -p "crates/cli/src/templates"
cp "/tests/crates/cli/src/templates/test.java" "crates/cli/src/templates/test.java"

# Test that Java binding support has been restored
# Check if the code contains the Java binding generation logic
if grep -q "TEST_JAVA_TEMPLATE" crates/cli/src/init.rs && \
   grep -q "Generate Java bindings" crates/cli/src/init.rs && \
   grep -q "bindings.java" crates/cli/src/init.rs; then
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
