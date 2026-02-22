#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder_compliance.rs" "crates/toml/tests/decoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_compliance.rs" "crates/toml/tests/encoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/decoder_compliance.rs" "crates/toml_edit/tests/decoder_compliance.rs"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/encoding"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/encoding/bad-codepoint.stderr" "crates/toml_edit/tests/fixtures/invalid/encoding/bad-codepoint.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/float"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/float/exp-trailing-us.stderr" "crates/toml_edit/tests/fixtures/invalid/float/exp-trailing-us.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/float"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/float/inf-capital.stderr" "crates/toml_edit/tests/fixtures/invalid/float/inf-capital.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/float"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/float/nan-capital.stderr" "crates/toml_edit/tests/fixtures/invalid/float/nan-capital.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/float"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/float/trailing-us-exp-1.stderr" "crates/toml_edit/tests/fixtures/invalid/float/trailing-us-exp-1.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/float"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/float/trailing-us-exp-2.stderr" "crates/toml_edit/tests/fixtures/invalid/float/trailing-us-exp-2.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/inline-table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/inline-table/bad-key-syntax.stderr" "crates/toml_edit/tests/fixtures/invalid/inline-table/bad-key-syntax.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/inline-table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/inline-table/dotted-key-conflict.stderr" "crates/toml_edit/tests/fixtures/invalid/inline-table/dotted-key-conflict.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/inline-table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/inline-table/nested_key_conflict.stderr" "crates/toml_edit/tests/fixtures/invalid/inline-table/nested_key_conflict.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/table/append-to-array-with-dotted-keys.stderr" "crates/toml_edit/tests/fixtures/invalid/table/append-to-array-with-dotted-keys.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/table/duplicate-key-dotted-array.stderr" "crates/toml_edit/tests/fixtures/invalid/table/duplicate-key-dotted-array.stderr"

# Run the decoder_compliance and encoder_compliance tests from toml crate
output=$(cargo test -p toml --test decoder_compliance -- --nocapture 2>&1)
test_status_decoder=$?
echo "$output"

output2=$(cargo test -p toml --test encoder_compliance -- --nocapture 2>&1)
test_status_encoder=$?
echo "$output2"

# Run the decoder_compliance tests from toml_edit crate
output3=$(cargo test -p toml_edit --test decoder_compliance -- --nocapture 2>&1)
test_status_edit=$?
echo "$output3"

# Check if the tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No decoder_compliance tests ran in toml package." >&2
  test_status_decoder=1
fi

if echo "$output2" | grep -q "running 0 tests"; then
  echo "ERROR: No encoder_compliance tests ran in toml package." >&2
  test_status_encoder=1
fi

if echo "$output3" | grep -q "running 0 tests"; then
  echo "ERROR: No decoder_compliance tests ran in toml_edit package." >&2
  test_status_edit=1
fi

# Overall test status (all must pass)
test_status=$((test_status_decoder || test_status_encoder || test_status_edit))

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
