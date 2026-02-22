#!/bin/bash

cd /app/src

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/api.rs" "tests/api.rs"
mkdir -p "tests"
cp "/tests/misc.rs" "tests/misc.rs"
mkdir -p "tests"
cp "/tests/word_boundary_ascii.rs" "tests/word_boundary_ascii.rs"
mkdir -p "tests"
cp "/tests/word_boundary_unicode.rs" "tests/word_boundary_unicode.rs"

# Run the default test (includes api, misc, word_boundary_unicode modules)
# and default-bytes test (includes word_boundary_ascii module)
cargo test --test default -- --nocapture && \
cargo test --test default-bytes -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
