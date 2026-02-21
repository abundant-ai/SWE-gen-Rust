#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
# The HEAD test files expect the new styling behavior after fix is applied
mkdir -p "tests/ui"
cp "/tests/ui/arg_required_else_help_stderr.toml" "tests/ui/arg_required_else_help_stderr.toml"
cp "/tests/ui/error_stderr.toml" "tests/ui/error_stderr.toml"
cp "/tests/ui/h_flag_stdout.toml" "tests/ui/h_flag_stdout.toml"
cp "/tests/ui/help_cmd_stdout.toml" "tests/ui/help_cmd_stdout.toml"
cp "/tests/ui/help_flag_stdout.toml" "tests/ui/help_flag_stdout.toml"

# Also need to copy HEAD version of stdio-fixture.rs because bug.patch simplified it
mkdir -p "src/bin"
cp "/tests/stdio-fixture.rs" "src/bin/stdio-fixture.rs"

# Rebuild after copying stdio-fixture.rs with all required features
cargo build --features help,usage,error-context,env,color,suggestions --bins

# Run the specific UI test targets for this PR
# Tests in tests/ui/*.toml - requires multiple features for stdio-fixture
cargo test --features help,usage,error-context,env,color,suggestions --test ui -- ui_tests --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
