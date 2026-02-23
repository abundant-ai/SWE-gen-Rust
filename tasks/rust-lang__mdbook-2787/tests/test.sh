#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/mdbook-driver/src/mdbook"
cp "/tests/crates/mdbook-driver/src/mdbook/tests.rs" "crates/mdbook-driver/src/mdbook/tests.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/config.rs" "tests/testsuite/config.rs"
mkdir -p "tests/testsuite/config/empty"
cp "/tests/testsuite/config/empty/book.toml" "tests/testsuite/config/empty/book.toml"
mkdir -p "tests/testsuite/config/empty/src"
cp "/tests/testsuite/config/empty/src/SUMMARY.md" "tests/testsuite/config/empty/src/SUMMARY.md"
mkdir -p "tests/testsuite/config/empty/src"
cp "/tests/testsuite/config/empty/src/chapter_1.md" "tests/testsuite/config/empty/src/chapter_1.md"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/init.rs" "tests/testsuite/init.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/main.rs" "tests/testsuite/main.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/renderer.rs" "tests/testsuite/renderer.rs"

# Run unit tests in mdbook-driver crate (tests in crates/mdbook-driver/src/mdbook/tests.rs)
cargo test -p mdbook-driver --lib -- --nocapture

# Run integration tests in testsuite for config, init, and renderer modules
cargo test --test testsuite config:: -- --nocapture
cargo test --test testsuite init:: -- --nocapture
cargo test --test testsuite renderer:: -- --nocapture

test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
