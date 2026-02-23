#!/bin/bash

cd /app/src

# Set environment variables for tests
export CI=1
export RUST_BACKTRACE=short

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/hir-ty/src/tests"
cp "/tests/crates/hir-ty/src/tests/coercion.rs" "crates/hir-ty/src/tests/coercion.rs"
mkdir -p "crates/hir-ty/src/tests"
cp "/tests/crates/hir-ty/src/tests/display_source_code.rs" "crates/hir-ty/src/tests/display_source_code.rs"
mkdir -p "crates/hir-ty/src/tests"
cp "/tests/crates/hir-ty/src/tests/traits.rs" "crates/hir-ty/src/tests/traits.rs"

# Run tests for coercion, display_source_code, and traits modules in hir-ty
# We need to run them separately as cargo test only accepts one test filter at a time
cargo test -p hir-ty --lib coercion -- --nocapture && \
cargo test -p hir-ty --lib display_source_code -- --nocapture && \
cargo test -p hir-ty --lib traits -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
