#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/de_enum.expanded.rs" "test_suite/tests/expand/de_enum.expanded.rs"
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/default_ty_param.expanded.rs" "test_suite/tests/expand/default_ty_param.expanded.rs"
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/generic_enum.expanded.rs" "test_suite/tests/expand/generic_enum.expanded.rs"
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/generic_struct.expanded.rs" "test_suite/tests/expand/generic_struct.expanded.rs"
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/lifetimes.expanded.rs" "test_suite/tests/expand/lifetimes.expanded.rs"
mkdir -p "test_suite/tests/expand"
cp "/tests/test_suite/tests/expand/named_map.expanded.rs" "test_suite/tests/expand/named_map.expanded.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_de.rs" "test_suite/tests/test_de.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_identifier.rs" "test_suite/tests/test_identifier.rs"

# Run the specific tests for this PR
cd /app/src/test_suite
cargo test --test test_de --test test_identifier -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
