#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/builder"
cp "/tests/builder/action.rs" "tests/builder/action.rs"
mkdir -p "tests/builder"
cp "/tests/builder/app_settings.rs" "tests/builder/app_settings.rs"
mkdir -p "tests/builder"
cp "/tests/builder/flags.rs" "tests/builder/flags.rs"
mkdir -p "tests/builder"
cp "/tests/builder/grouped_values.rs" "tests/builder/grouped_values.rs"
mkdir -p "tests/builder"
cp "/tests/builder/indices.rs" "tests/builder/indices.rs"
mkdir -p "tests/builder"
cp "/tests/builder/multiple_occurrences.rs" "tests/builder/multiple_occurrences.rs"
mkdir -p "tests/builder"
cp "/tests/builder/multiple_values.rs" "tests/builder/multiple_values.rs"
mkdir -p "tests/derive"
cp "/tests/derive/flags.rs" "tests/derive/flags.rs"
mkdir -p "tests/derive"
cp "/tests/derive/options.rs" "tests/derive/options.rs"

# Run specific test modules for builder tests
cargo test --test builder builder::action -- --nocapture
builder_action_status=$?

cargo test --test builder builder::app_settings -- --nocapture
builder_app_settings_status=$?

cargo test --test builder builder::flags -- --nocapture
builder_flags_status=$?

cargo test --test builder builder::grouped_values -- --nocapture
builder_grouped_values_status=$?

cargo test --test builder builder::indices -- --nocapture
builder_indices_status=$?

cargo test --test builder builder::multiple_occurrences -- --nocapture
builder_multiple_occurrences_status=$?

cargo test --test builder builder::multiple_values -- --nocapture
builder_multiple_values_status=$?

# Run specific test modules for derive tests
cargo test --test derive derive::flags -- --nocapture
derive_flags_status=$?

cargo test --test derive derive::options -- --nocapture
derive_options_status=$?

# Check if all tests passed
test_status=0
if [ $builder_action_status -ne 0 ] || [ $builder_app_settings_status -ne 0 ] || [ $builder_flags_status -ne 0 ] || \
   [ $builder_grouped_values_status -ne 0 ] || [ $builder_indices_status -ne 0 ] || \
   [ $builder_multiple_occurrences_status -ne 0 ] || [ $builder_multiple_values_status -ne 0 ] || \
   [ $derive_flags_status -ne 0 ] || [ $derive_options_status -ne 0 ]; then
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
