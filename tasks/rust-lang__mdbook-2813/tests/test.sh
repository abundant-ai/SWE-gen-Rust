#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-core/src/book"
cp "/tests/crates/mdbook-core/src/book/tests.rs" "crates/mdbook-core/src/book/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/config.rs" "tests/testsuite/config.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/preprocessor.rs" "tests/testsuite/preprocessor.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/renderer.rs" "tests/testsuite/renderer.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/search.rs" "tests/testsuite/search.rs"

# Run unit tests in mdbook-core package
cargo test -p mdbook-core --locked -- --nocapture
test_status=$?

# Run specific tests from the testsuite (only the ones from the copied modules)
# We run tests matching the module names: config, preprocessor, renderer, search
# Skip failing_preprocessor as it's not directly related to the items/sections bug fix
if [ $test_status -eq 0 ]; then
    cargo test --test testsuite config:: --locked -- --nocapture && \
    cargo test --test testsuite preprocessor:: --locked -- --nocapture --skip failing_preprocessor && \
    cargo test --test testsuite renderer:: --locked -- --nocapture && \
    cargo test --test testsuite search:: --locked -- --nocapture
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
