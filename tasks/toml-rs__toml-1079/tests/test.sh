#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder_compliance.rs" "crates/toml/tests/decoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_compliance.rs" "crates/toml/tests/encoder_compliance.rs"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-04.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-04.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-06.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-06.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/string"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/string/bad-escape-6.stderr" "crates/toml/tests/snapshots/invalid/ext/string/bad-escape-6.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/table"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/table/append-with-dotted-keys-3.stderr" "crates/toml/tests/snapshots/invalid/ext/table/append-with-dotted-keys-3.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/bad-key-syntax.stderr" "crates/toml/tests/snapshots/invalid/inline-table/bad-key-syntax.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/empty-02.stderr" "crates/toml/tests/snapshots/invalid/inline-table/empty-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/empty-03.stderr" "crates/toml/tests/snapshots/invalid/inline-table/empty-03.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-close-01.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-close-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-close-02.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-close-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-comma-01.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-comma-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-comma-02.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-comma-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/key"
cp "/tests/crates/toml/tests/snapshots/invalid/key/end-in-escape.stderr" "crates/toml/tests/snapshots/invalid/key/end-in-escape.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/string"
cp -r "/tests/crates/toml/tests/snapshots/invalid/string/"* "crates/toml/tests/snapshots/invalid/string/"
mkdir -p "crates/toml/tests/snapshots/invalid/spec-1.1.0"
cp -r "/tests/crates/toml/tests/snapshots/invalid/spec-1.1.0/"* "crates/toml/tests/snapshots/invalid/spec-1.1.0/" 2>/dev/null || true

# This PR adds TOML 1.1.0 support, which affects the parser and error messages
# Run all tests in the toml crate
cargo test -p toml
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
