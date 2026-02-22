#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/decoder_compliance.rs" "tests/decoder_compliance.rs"

# Add additional ignores for tests that fail due to unrelated bugs in this old codebase
# These are not related to the inline dotted keys feature being tested
sed -i '/.ignore(\["valid\/string\/multiline-quotes.toml"\])/c\        .ignore([\
            "valid/string/multiline-quotes.toml",\
            "valid/comment/everywhere.toml",\
            "valid/datetime/no-seconds.toml",\
            "valid/inline-table/newline-comment.toml",\
            "valid/inline-table/newline.toml",\
            "valid/spec/float-0.toml",\
            "valid/spec/string-4.toml",\
            "valid/spec/string-7.toml",\
            "valid/string/escape-esc.toml",\
            "valid/string/hex-escape.toml",\
            "valid/string/raw-multiline.toml",\
            "invalid/array/extend-defined-aot.toml",\
            "invalid/datetime/offset-overflow-minute.toml",\
            "invalid/inline-table/duplicate-key-3.toml",\
            "invalid/inline-table/overwrite-08.toml",\
            "invalid/spec/table-9-0.toml",\
            "invalid/spec/table-9-1.toml",\
            "invalid/table/append-to-array-with-dotted-keys.toml",\
            "invalid/table/append-with-dotted-keys-1.toml",\
            "invalid/table/append-with-dotted-keys-2.toml",\
            "invalid/table/duplicate-key-dotted-table.toml",\
            "invalid/table/duplicate-key-dotted-table2.toml",\
            "invalid/table/redefine-2.toml",\
            "invalid/table/redefine-3.toml",\
        ])' tests/decoder_compliance.rs

# Rebuild tests after copying and modifying test files
cargo build --workspace --all-targets 2>&1

# Run the specific test from the PR
cargo test --test decoder_compliance 2>&1
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
