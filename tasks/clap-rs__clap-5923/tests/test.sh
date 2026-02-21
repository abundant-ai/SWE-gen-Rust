#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/common.rs" "clap_complete/tests/testsuite/common.rs"
mkdir -p "clap_complete_nushell/tests"
cp "/tests/clap_complete_nushell/tests/common.rs" "clap_complete_nushell/tests/common.rs"

# Check if 'gen' is used as an identifier in the modified code
# The reserved keyword 'gen' should not appear as a parameter, variable, or function name
# We check in source files (not comments) for the patterns we care about
if grep -r '\bgen\b' clap_complete/src/aot/generator/mod.rs clap_complete/examples/*.rs clap_complete_nushell/tests/common.rs clap_complete/tests/testsuite/common.rs 2>/dev/null | grep -v '//\|/\*\|#\[' | grep -E '(fn|let|for).*\bgen\b'; then
  # Found 'gen' being used as an identifier
  test_status=1
else
  # No problematic use of 'gen' found
  test_status=0
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
