#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/add.bg.js" "crates/cli/tests/reference/add.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/add.d.ts" "crates/cli/tests/reference/add.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/add.wat" "crates/cli/tests/reference/add.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-empty.bg.js" "crates/cli/tests/reference/anyref-empty.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.bg.js" "crates/cli/tests/reference/anyref-import-catch.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.d.ts" "crates/cli/tests/reference/anyref-import-catch.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-nop.bg.js" "crates/cli/tests/reference/anyref-nop.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-nop.d.ts" "crates/cli/tests/reference/anyref-nop.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.d.ts" "crates/cli/tests/reference/async-number.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.d.ts" "crates/cli/tests/reference/async-void.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.bg.js" "crates/cli/tests/reference/builder.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.d.ts" "crates/cli/tests/reference/builder.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.bg.js" "crates/cli/tests/reference/closures.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.d.ts" "crates/cli/tests/reference/closures.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.bg.js" "crates/cli/tests/reference/constructor.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.d.ts" "crates/cli/tests/reference/constructor.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.bg.js" "crates/cli/tests/reference/default-class.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.d.ts" "crates/cli/tests/reference/default-class.d.ts"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.rs" "crates/cli/tests/reference/default-class.rs"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.wat" "crates/cli/tests/reference/default-class.wat"

# Run reference tests to verify deterministic output
# The test compiles reference/*.rs files and compares against expected *.js, *.d.ts, *.wat outputs
# Run tests for: add, anyref-empty, anyref-import-catch, anyref-nop, async-number, async-void,
# builder, closures, constructor, default-class
cd crates/cli

# Run each test individually to ensure they all pass
all_passed=true
for test_name in \
  "reference::runtest::test_01_add_rs" \
  "reference::runtest::test_02_anyref_empty_rs" \
  "reference::runtest::test_03_anyref_import_catch_rs" \
  "reference::runtest::test_04_anyref_nop_rs" \
  "reference::runtest::test_05_async_number_rs" \
  "reference::runtest::test_06_async_void_rs" \
  "reference::runtest::test_07_builder_rs" \
  "reference::runtest::test_08_closures_rs" \
  "reference::runtest::test_09_constructor_rs" \
  "reference::runtest::test_10_default_class_rs"
do
  echo "Running test: $test_name"
  if ! cargo test -p wasm-bindgen-cli --test wasm-bindgen "$test_name" -- --nocapture; then
    all_passed=false
    break
  fi
done

if $all_passed; then
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
