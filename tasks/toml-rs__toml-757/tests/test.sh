#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/display.rs" "crates/toml/tests/testsuite/display.rs"
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/parse.rs" "crates/toml_edit/tests/testsuite/parse.rs"

# Run the testsuite integration test for both packages
cargo test -p toml --test testsuite -- --nocapture
test_status_toml=$?

cargo test -p toml_edit --test testsuite -- --nocapture
test_status_toml_edit=$?

# Both tests must pass
if [ $test_status_toml -eq 0 ] && [ $test_status_toml_edit -eq 0 ]; then
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
