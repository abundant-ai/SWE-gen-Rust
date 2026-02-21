#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints=warn"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/compile-fail/transparent"
cp "/tests/test_suite/tests/compile-fail/transparent/at_most_one.rs" "test_suite/tests/compile-fail/transparent/at_most_one.rs"
mkdir -p "test_suite/tests/compile-fail/transparent"
cp "/tests/test_suite/tests/compile-fail/transparent/de_at_least_one.rs" "test_suite/tests/compile-fail/transparent/de_at_least_one.rs"
mkdir -p "test_suite/tests/compile-fail/transparent"
cp "/tests/test_suite/tests/compile-fail/transparent/ser_at_least_one.rs" "test_suite/tests/compile-fail/transparent/ser_at_least_one.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_gen.rs" "test_suite/tests/test_gen.rs"

# Run the specific tests for this PR with unstable feature enabled
# The main tests for the transparent feature are in test_annotations and test_gen
cd /app/src/test_suite
cargo test --features unstable --test test_annotations --test test_gen -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
