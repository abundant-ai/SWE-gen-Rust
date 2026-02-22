#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_lex/tests"
cp "/tests/clap_lex/tests/parsed.rs" "clap_lex/tests/parsed.rs"
mkdir -p "clap_lex/tests"
cp "/tests/clap_lex/tests/shorts.rs" "clap_lex/tests/shorts.rs"

# Run the specific tests in clap_lex package
output=$(cargo test -p clap_lex --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
