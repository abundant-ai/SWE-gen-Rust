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
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/easy_decoder_compliance.rs" "crates/toml_edit/tests/easy_decoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/easy_encoder_compliance.rs" "crates/toml_edit/tests/easy_encoder_compliance.rs"
mkdir -p "crates/toml_edit/tests"
cp "/tests/crates/toml_edit/tests/encoder_compliance.rs" "crates/toml_edit/tests/encoder_compliance.rs"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/encoding"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-multiline-literal.stderr" "crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-multiline-literal.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/encoding"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-multiline.stderr" "crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-multiline.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/encoding"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-string-literal.stderr" "crates/toml_edit/tests/fixtures/invalid/encoding/bad-utf8-in-string-literal.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/inline-table-2-0.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/inline-table-2-0.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/inline-table-3-0.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/inline-table-3-0.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/key-value-pair-1.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/key-value-pair-1.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/keys-2.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/keys-2.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/string-4-0.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/string-4-0.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/string-7-0.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/string-7-0.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/table-9-0.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/table-9-0.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/spec"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/spec/table-9-1.stderr" "crates/toml_edit/tests/fixtures/invalid/spec/table-9-1.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-1.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-1.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-2.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-2.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-3.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-3.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-4.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-4.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-5.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc-5.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/string"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc.stderr" "crates/toml_edit/tests/fixtures/invalid/string/bad-hex-esc.stderr"
mkdir -p "crates/toml_edit/tests/fixtures/invalid/table"
cp "/tests/crates/toml_edit/tests/fixtures/invalid/table/duplicate-key-dotted-table2.stderr" "crates/toml_edit/tests/fixtures/invalid/table/duplicate-key-dotted-table2.stderr"

# Copy the custom test that specifically tests PR #460
cp "/tests/crates/toml_edit/tests/test_pr460.rs" "crates/toml_edit/tests/test_pr460.rs"

# In Oracle mode, /solution directory is mounted and contains fix.patch
# In NOP mode, /solution directory doesn't exist
# Apply the fix if available (Oracle mode only)
if [ -d "/solution" ] && [ -f "/solution/fix.patch" ]; then
    echo "Oracle mode detected - applying fix.patch..."
    patch -p1 < /solution/fix.patch

    # Rebuild after applying the fix
    cargo build --workspace --all-targets 2>&1 | head -20
fi

# Run the specific test for PR #460
# This test will FAIL with the buggy code (NOP) and PASS with the fix (Oracle)
cargo test -p toml_edit --test test_pr460 -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
