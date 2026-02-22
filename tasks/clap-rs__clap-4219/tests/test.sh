#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/app_settings.rs" "tests/builder/app_settings.rs"
mkdir -p "tests/derive"
cp "/tests/derive/subcommands.rs" "tests/derive/subcommands.rs"

# Run the specific test modules for this PR
# The modified test files are app_settings.rs and subcommands.rs
# In Rust's test organization, these are modules within the 'builder' and 'derive' integration tests

# Run builder integration test (includes app_settings module)
cargo test --test builder app_settings -- --nocapture
test_status=$?

# Run derive integration test (includes subcommands module)
if [ $test_status -eq 0 ]; then
  cargo test --test derive subcommands -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
