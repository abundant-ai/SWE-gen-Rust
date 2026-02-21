#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/compliance"
cp "/tests/crates/toml/tests/compliance/main.rs" "crates/toml/tests/compliance/main.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder.rs" "crates/toml/tests/decoder.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder_compliance.rs" "crates/toml/tests/decoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder.rs" "crates/toml/tests/encoder.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_compliance.rs" "crates/toml/tests/encoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_pretty_compliance.rs" "crates/toml/tests/encoder_pretty_compliance.rs"
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/main.rs" "crates/toml/tests/serde/main.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/main.rs" "crates/toml/tests/testsuite/main.rs"

# Run tests for the specific test files in the toml crate
# Test files: compliance, decoder, decoder_compliance, encoder, encoder_compliance, encoder_pretty_compliance, serde, testsuite
# Need to enable parse, display, and serde features for the tests to compile and run
cargo test -p toml --features "parse,display,serde" --test compliance --test decoder --test decoder_compliance --test encoder --test encoder_compliance --test encoder_pretty_compliance --test serde --test testsuite
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
