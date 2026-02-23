#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
# Need to restore the invalid_section_missing_flags test that was deleted by bug.patch
mkdir -p "tests/testsuite/cargo_remove/invalid_section_missing_flags/in"
cp "/tests/testsuite/cargo_remove/invalid_section_missing_flags/in/Cargo.toml" "tests/testsuite/cargo_remove/invalid_section_missing_flags/in/Cargo.toml"
mkdir -p "tests/testsuite/cargo_remove/invalid_section_missing_flags/out"
cp "/tests/testsuite/cargo_remove/invalid_section_missing_flags/out/Cargo.toml" "tests/testsuite/cargo_remove/invalid_section_missing_flags/out/Cargo.toml"
mkdir -p "tests/testsuite/cargo_remove/invalid_section_missing_flags"
cp "/tests/testsuite/cargo_remove/invalid_section_missing_flags/mod.rs" "tests/testsuite/cargo_remove/invalid_section_missing_flags/mod.rs"
cp "/tests/testsuite/cargo_remove/invalid_section_missing_flags/stderr.term.svg" "tests/testsuite/cargo_remove/invalid_section_missing_flags/stderr.term.svg"
# Also need to restore mod.rs which includes the test module
mkdir -p "tests/testsuite/cargo_remove"
cp "/tests/testsuite/cargo_remove/mod.rs" "tests/testsuite/cargo_remove/mod.rs"

# Run specific tests from the PR
# Tests: cargo_remove (tests all cargo remove functionality)
cargo test -p cargo --test testsuite cargo_remove -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
