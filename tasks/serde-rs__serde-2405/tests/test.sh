#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/ui/malformed"
cp "/tests/test_suite/tests/ui/malformed/cut_off.stderr" "test_suite/tests/ui/malformed/cut_off.stderr"
cp "/tests/test_suite/tests/ui/malformed/not_list.stderr" "test_suite/tests/ui/malformed/not_list.stderr"
mkdir -p "test_suite/tests/ui/unexpected-literal"
cp "/tests/test_suite/tests/ui/unexpected-literal/container.stderr" "test_suite/tests/ui/unexpected-literal/container.stderr"
cp "/tests/test_suite/tests/ui/unexpected-literal/field.stderr" "test_suite/tests/ui/unexpected-literal/field.stderr"
cp "/tests/test_suite/tests/ui/unexpected-literal/variant.stderr" "test_suite/tests/ui/unexpected-literal/variant.stderr"
mkdir -p "test_suite/tests/ui/remote"
cp "/tests/test_suite/tests/ui/remote/unknown_field.stderr" "test_suite/tests/ui/remote/unknown_field.stderr"
cp "/tests/test_suite/tests/ui/remote/wrong_de.stderr" "test_suite/tests/ui/remote/wrong_de.stderr"

# Run the specific compiletest tests for this PR
cd /app/src/test_suite
cargo test --test compiletest -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
