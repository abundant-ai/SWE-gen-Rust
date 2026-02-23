#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-markdown/src"
cp "/tests/crates/mdbook-markdown/src/tests.rs" "crates/mdbook-markdown/src/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/markdown.rs" "tests/testsuite/markdown.rs"

# Run the specific tests from the PR
# - Unit tests in crates/mdbook-markdown/src/tests.rs
# - Integration tests in tests/testsuite/markdown.rs (part of testsuite integration test binary)
cargo test --workspace --locked -p mdbook-markdown --lib -- --nocapture && \
cargo test --workspace --locked --test testsuite markdown:: -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
