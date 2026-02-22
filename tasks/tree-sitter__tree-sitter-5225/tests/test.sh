#!/bin/bash

cd /app/src/lib/binding_web

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test"
cp "/tests/lib/binding_web/test/memory.test.ts" "test/memory.test.ts"
cp "/tests/lib/binding_web/test/memory.ts" "test/memory.ts"
cp "/tests/lib/binding_web/test/memory_unsupported.test.ts" "test/memory_unsupported.test.ts"

# Run the specific memory management tests using vitest
# These tests verify that the automatic memory management works correctly
npx vitest run test/memory.test.ts test/memory_unsupported.test.ts --coverage.enabled=false
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
