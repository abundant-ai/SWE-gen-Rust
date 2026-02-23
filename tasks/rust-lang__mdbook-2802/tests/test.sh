#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-driver/src/mdbook"
cp "/tests/crates/mdbook-driver/src/mdbook/tests.rs" "crates/mdbook-driver/src/mdbook/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/book_test.rs" "tests/testsuite/book_test.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/preprocessor.rs" "tests/testsuite/preprocessor.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/renderer.rs" "tests/testsuite/renderer.rs"

# Run unit tests in mdbook-driver crate
cargo test --package mdbook-driver --lib -- --nocapture
driver_status=$?

# Run only the specific new tests that test the with_renderer/with_preprocessor overwrite behavior
cargo test --test testsuite preprocessor::with_preprocessor_same_name -- --nocapture
preprocessor_status=$?

cargo test --test testsuite renderer::with_renderer_same_name -- --nocapture
renderer_status=$?

# Overall test status - all must pass
test_status=$((driver_status + preprocessor_status + renderer_status))

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
