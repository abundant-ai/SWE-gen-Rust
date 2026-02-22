#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/decoder.rs" "crates/test-suite/tests/decoder.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/decoder_compliance.rs" "crates/test-suite/tests/decoder_compliance.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/encoder.rs" "crates/test-suite/tests/encoder.rs"
mkdir -p "crates/test-suite/tests"
cp "/tests/crates/test-suite/tests/encoder_compliance.rs" "crates/test-suite/tests/encoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/decoder.rs" "crates/toml_edit/tests/decoder.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/decoder_compliance.rs" "crates/toml_edit/tests/decoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/easy_decoder.rs" "crates/toml_edit/tests/easy_decoder.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/easy_decoder_compliance.rs" "crates/toml_edit/tests/easy_decoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/easy_encoder.rs" "crates/toml_edit/tests/easy_encoder.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/encoder.rs" "crates/toml_edit/tests/encoder.rs"

# Rebuild after copying test files
# Note: In Oracle mode, solve.sh has already applied fix.patch before this script runs
# This ensures the test binary includes the updated tests and implementation
cargo build --workspace --all-targets 2>&1 | head -20

# Run the specific integration tests for both toml_test_suite and toml_edit packages
cargo test -p toml_test_suite --test decoder --test decoder_compliance --test encoder --test encoder_compliance -- --nocapture
test_status1=$?
cargo test -p toml_edit --test decoder --test decoder_compliance --test easy_decoder --test easy_decoder_compliance --test easy_encoder --test encoder -- --nocapture
test_status2=$?

# Both test suites must pass
if [ $test_status1 -eq 0 ] && [ $test_status2 -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
