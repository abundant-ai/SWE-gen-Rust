#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de_error.rs" "test_suite/tests/test_de_error.rs"

# Remove trybuild dependency to avoid compilation issues
sed -i '/trybuild/d; /automod/d; /rustversion/d' test_suite/Cargo.toml
rm -f test_suite/tests/compiletest.rs test_suite/tests/regression.rs

# Check for unexpected_cfgs warning in the test file
# The bug is that test_systemtime_overflow has an unnecessary/incorrect cfg attribute
# At HEAD (fixed): no cfg attribute, no warning
# At BASE (buggy): has #[cfg(not(no_systemtime_checked_add))], which causes unexpected_cfgs warning
cargo test --test test_de_error -- --nocapture 2>&1 | tee /tmp/test_output.txt

# Check if there's an unexpected_cfgs warning for systemtime_checked_add
if grep -q "systemtime_checked_add" /tmp/test_output.txt && grep -q "unexpected.*cfg" /tmp/test_output.txt; then
  # Found the warning - this is the buggy state
  test_status=1
else
  # No warning - this is the fixed state
  test_status=0
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
