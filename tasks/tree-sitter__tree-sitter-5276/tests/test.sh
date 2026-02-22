#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/wasm_language_test.rs" "crates/cli/src/tests/wasm_language_test.rs"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_clobber_region"
cp "/tests/fixtures/test_grammars/wasm_realloc_clobber_region/corpus.txt" "test/fixtures/test_grammars/wasm_realloc_clobber_region/corpus.txt"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_clobber_region"
cp "/tests/fixtures/test_grammars/wasm_realloc_clobber_region/grammar.js" "test/fixtures/test_grammars/wasm_realloc_clobber_region/grammar.js"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_clobber_region"
cp "/tests/fixtures/test_grammars/wasm_realloc_clobber_region/scanner.c" "test/fixtures/test_grammars/wasm_realloc_clobber_region/scanner.c"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_overflow_heap"
cp "/tests/fixtures/test_grammars/wasm_realloc_overflow_heap/corpus.txt" "test/fixtures/test_grammars/wasm_realloc_overflow_heap/corpus.txt"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_overflow_heap"
cp "/tests/fixtures/test_grammars/wasm_realloc_overflow_heap/grammar.js" "test/fixtures/test_grammars/wasm_realloc_overflow_heap/grammar.js"
mkdir -p "test/fixtures/test_grammars/wasm_realloc_overflow_heap"
cp "/tests/fixtures/test_grammars/wasm_realloc_overflow_heap/scanner.c" "test/fixtures/test_grammars/wasm_realloc_overflow_heap/scanner.c"

# Rebuild to pick up the new test files (with wasm feature enabled)
cargo build --release --package tree-sitter-cli --features wasm 2>&1

# Run the specific realloc tests that were added/modified in this PR
# These tests verify that the fix for WASM realloc overflow/clobber issues works correctly
cargo test --package tree-sitter-cli --lib --features wasm tests::wasm_language_test::test_wasm_realloc_clobber_region -- --nocapture --show-output 2>&1
test1_status=$?
cargo test --package tree-sitter-cli --lib --features wasm tests::wasm_language_test::test_wasm_realloc_smaller_size -- --nocapture --show-output 2>&1
test2_status=$?
cargo test --package tree-sitter-cli --lib --features wasm tests::wasm_language_test::test_wasm_stdlib_symbols -- --nocapture --show-output 2>&1
test3_status=$?

# All tests must pass
if [ $test1_status -eq 0 ] && [ $test2_status -eq 0 ] && [ $test3_status -eq 0 ]; then
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
