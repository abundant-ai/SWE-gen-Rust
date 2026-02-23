#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1
export CARGO_INCREMENTAL=0

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/testsuite/cargo_add/help"
cp "/tests/testsuite/cargo_add/help/stdout.term.svg" "tests/testsuite/cargo_add/help/stdout.term.svg"
mkdir -p "tests/testsuite/cargo_bench/help"
cp "/tests/testsuite/cargo_bench/help/stdout.term.svg" "tests/testsuite/cargo_bench/help/stdout.term.svg"
mkdir -p "tests/testsuite/cargo_build/help"
cp "/tests/testsuite/cargo_build/help/stdout.term.svg" "tests/testsuite/cargo_build/help/stdout.term.svg"
mkdir -p "tests/testsuite/cargo_check/help"
cp "/tests/testsuite/cargo_check/help/stdout.term.svg" "tests/testsuite/cargo_check/help/stdout.term.svg"
mkdir -p "tests/testsuite/cargo_clean/help"
cp "/tests/testsuite/cargo_clean/help/stdout.term.svg" "tests/testsuite/cargo_clean/help/stdout.term.svg"
mkdir -p "tests/testsuite/cargo_doc/help"
cp "/tests/testsuite/cargo_doc/help/stdout.term.svg" "tests/testsuite/cargo_doc/help/stdout.term.svg"

# Run the specific test modules for this PR
# The test files are help snapshots for: cargo_add, cargo_bench, cargo_build, cargo_check, cargo_clean, cargo_doc
# Run each test module separately and track if any fail
test_status=0

cargo test -p cargo --test testsuite cargo_add::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite cargo_bench::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite cargo_build::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite cargo_check::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite cargo_clean::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

cargo test -p cargo --test testsuite cargo_doc::help -- --nocapture
if [ $? -ne 0 ]; then test_status=1; fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
