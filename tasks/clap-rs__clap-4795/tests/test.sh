#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/derive"
cp "/tests/derive/flatten.rs" "tests/derive/flatten.rs"
mkdir -p "tests/derive"
cp "/tests/derive/groups.rs" "tests/derive/groups.rs"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/group_name_attribute.rs" "tests/derive_ui/group_name_attribute.rs"
mkdir -p "tests/derive_ui"
cp "/tests/derive_ui/group_name_attribute.stderr" "tests/derive_ui/group_name_attribute.stderr"

# Run the derive tests (includes flatten and groups modules) and derive_ui tests
# Need to enable derive feature for these tests to run
output=$(cargo test --features derive --test derive --test derive_ui --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
