#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/occurrences.rs" "tests/builder/occurrences.rs"
mkdir -p "tests/derive"
cp "/tests/derive/occurrences.rs" "tests/derive/occurrences.rs"
mkdir -p "tests"
cp "/tests/examples.rs" "tests/examples.rs"
mkdir -p "tests"
cp "/tests/ui.rs" "tests/ui.rs"

# Run the specific integration tests that contain the modified test files
# - tests/builder/occurrences.rs is part of the builder integration test
# - tests/derive/occurrences.rs is part of the derive integration test
# - tests/examples.rs is the examples integration test
# - tests/ui.rs is the ui integration test

# Run builder tests (includes builder/occurrences.rs)
cargo test --test builder --no-fail-fast -- --nocapture
builder_status=$?

# Run derive tests (includes derive/occurrences.rs)
cargo test --test derive --no-fail-fast -- --nocapture
derive_status=$?

# Run examples integration test
cargo test --test examples --no-fail-fast -- --nocapture
examples_status=$?

# Run ui integration test
cargo test --test ui --no-fail-fast -- --nocapture
ui_status=$?

# Check if all tests passed
if [ $builder_status -eq 0 ] && [ $derive_status -eq 0 ] && [ $examples_status -eq 0 ] && [ $ui_status -eq 0 ]; then
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
