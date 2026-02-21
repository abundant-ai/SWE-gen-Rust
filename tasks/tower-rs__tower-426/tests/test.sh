#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower/tests/steer"
cp "/tests/tower/tests/steer/main.rs" "tower/tests/steer/main.rs"

# Run the specific integration test for steer
# Capture output to check if tests actually ran
test_output=$(cargo test --test steer --all-features -- --nocapture 2>&1)
test_status=$?
echo "$test_output"

# Check if no tests ran (which means the feature is disabled in BASE state)
if echo "$test_output" | grep -q "running 0 tests"; then
    echo "Error: No tests ran. The 'steer' feature may be disabled." >&2
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
