#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/src/tests"
cp "/tests/crates/cli/src/tests/wasm_language_test.rs" "crates/cli/src/tests/wasm_language_test.rs"
mkdir -p "test/fixtures/test_grammars/wasm_realloc"
cp "/tests/fixtures/test_grammars/wasm_realloc/corpus.txt" "test/fixtures/test_grammars/wasm_realloc/corpus.txt"
mkdir -p "test/fixtures/test_grammars/wasm_realloc"
cp "/tests/fixtures/test_grammars/wasm_realloc/grammar.js" "test/fixtures/test_grammars/wasm_realloc/grammar.js"
mkdir -p "test/fixtures/test_grammars/wasm_realloc"
cp "/tests/fixtures/test_grammars/wasm_realloc/scanner.c" "test/fixtures/test_grammars/wasm_realloc/scanner.c"

# Rebuild to pick up the new test files (with wasm feature enabled)
cargo build --release --package tree-sitter-cli --features wasm 2>&1

# Run the specific realloc tests that were added/modified in this PR
cargo test --package tree-sitter-cli --lib --features wasm tests::wasm_language_test::test_wasm_realloc_smaller_size -- --nocapture --show-output 2>&1
test1_status=$?
cargo test --package tree-sitter-cli --lib --features wasm tests::wasm_language_test::test_wasm_stdlib_symbols -- --nocapture --show-output 2>&1
test2_status=$?

# All tests must pass
if [ $test1_status -eq 0 ] && [ $test2_status -eq 0 ]; then
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
