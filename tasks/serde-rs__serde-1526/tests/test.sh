#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"
mkdir -p "test_suite/tests/ui/conflict"
cp "/tests/test_suite/tests/ui/conflict/from-try-from.rs" "test_suite/tests/ui/conflict/from-try-from.rs"
mkdir -p "test_suite/tests/ui/conflict"
cp "/tests/test_suite/tests/ui/conflict/from-try-from.stderr" "test_suite/tests/ui/conflict/from-try-from.stderr"
mkdir -p "test_suite/tests/ui/transparent"
cp "/tests/test_suite/tests/ui/transparent/with_try_from.rs" "test_suite/tests/ui/transparent/with_try_from.rs"
mkdir -p "test_suite/tests/ui/transparent"
cp "/tests/test_suite/tests/ui/transparent/with_try_from.stderr" "test_suite/tests/ui/transparent/with_try_from.stderr"
mkdir -p "test_suite/tests/ui/type-attribute"
cp "/tests/test_suite/tests/ui/type-attribute/try_from.rs" "test_suite/tests/ui/type-attribute/try_from.rs"
mkdir -p "test_suite/tests/ui/type-attribute"
cp "/tests/test_suite/tests/ui/type-attribute/try_from.stderr" "test_suite/tests/ui/type-attribute/try_from.stderr"

# Run the specific tests for this PR
cd /app/src/test_suite
cargo test --test test_annotations -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
