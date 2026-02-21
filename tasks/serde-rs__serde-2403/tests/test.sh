#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"
# Note: partially_tagged_wrong_order test files are NEW in this PR.
# They will be added when fix.patch is applied (Oracle agent only).

# Copy updated .stderr files that have different error messages in newer Rust
mkdir -p "test_suite/tests/ui/remote"
cp "/tests/test_suite/tests/ui/remote/unknown_field.stderr" "test_suite/tests/ui/remote/unknown_field.stderr"
cp "/tests/test_suite/tests/ui/remote/wrong_de.stderr" "test_suite/tests/ui/remote/wrong_de.stderr"

# Run both the regular test and the UI compiletest for this PR
cd /app/src/test_suite

# Run the test_annotations test file
cargo test --test test_annotations -- --nocapture
test_status=$?

# If that passed, also run the compiletest UI tests
if [ $test_status -eq 0 ]; then
  cargo test --test compiletest -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
