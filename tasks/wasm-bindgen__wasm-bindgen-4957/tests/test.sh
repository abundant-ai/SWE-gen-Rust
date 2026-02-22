#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/anyref-param-owned.wat" "crates/cli-support/src/transforms/externref/tests/anyref-param-owned.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/anyref-param.wat" "crates/cli-support/src/transforms/externref/tests/anyref-param.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/clone-ref-intrinsic.wat" "crates/cli-support/src/transforms/externref/tests/clone-ref-intrinsic.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/drop-ref-intrinsic.wat" "crates/cli-support/src/transforms/externref/tests/drop-ref-intrinsic.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/import-anyref-owned.wat" "crates/cli-support/src/transforms/externref/tests/import-anyref-owned.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/import-anyref-ret.wat" "crates/cli-support/src/transforms/externref/tests/import-anyref-ret.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/import-anyref.wat" "crates/cli-support/src/transforms/externref/tests/import-anyref.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/mixed-export.wat" "crates/cli-support/src/transforms/externref/tests/mixed-export.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/mixed.wat" "crates/cli-support/src/transforms/externref/tests/mixed.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/ret-anyref.wat" "crates/cli-support/src/transforms/externref/tests/ret-anyref.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/table-grow-intrinsic.wat" "crates/cli-support/src/transforms/externref/tests/table-grow-intrinsic.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/table-set-null-intrinsic.wat" "crates/cli-support/src/transforms/externref/tests/table-set-null-intrinsic.wat"
mkdir -p "crates/cli-support/src/transforms/externref/tests"
cp "/tests/crates/cli-support/src/transforms/externref/tests/tee-before-grow.wat" "crates/cli-support/src/transforms/externref/tests/tee-before-grow.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/add.wat" "crates/cli/tests/reference/add.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-empty.wat" "crates/cli/tests/reference/anyref-empty.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.wat" "crates/cli/tests/reference/anyref-import-catch.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-nop.wat" "crates/cli/tests/reference/anyref-nop.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.wat" "crates/cli/tests/reference/builder.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.wat" "crates/cli/tests/reference/constructor.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/custom-section.wat" "crates/cli/tests/reference/custom-section.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.wat" "crates/cli/tests/reference/default-class.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-function.wat" "crates/cli/tests/reference/default-function.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/echo.wat" "crates/cli/tests/reference/echo.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/empty.wat" "crates/cli/tests/reference/empty.wat"

# Run externref tests (WAT files in crates/cli-support/src/transforms/externref/tests/)
# The rstest framework will discover and run all the copied WAT files
cargo test -p wasm-bindgen-cli-support externref::tests::run_test -- --nocapture
externref_status=$?

# Run reference tests for the specific test files that have updated WAT files
# Only run the tests for which we have updated WAT expected outputs
cargo test -p wasm-bindgen-cli reference::runtest::test_01_add_rs -- --nocapture
status1=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_02_anyref_empty_rs -- --nocapture
status2=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_03_anyref_import_catch_rs -- --nocapture
status3=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_04_anyref_nop_rs -- --nocapture
status4=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_05_async_number_rs -- --nocapture
status5=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_06_async_void_rs -- --nocapture
status6=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_07_builder_rs -- --nocapture
status7=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_08_closures_rs -- --nocapture
status8=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_09_constructor_rs -- --nocapture
status9=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_10_custom_section_rs -- --nocapture
status10=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_11_default_class_rs -- --nocapture
status11=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_12_default_function_rs -- --nocapture
status12=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_13_echo_rs -- --nocapture
status13=$?
cargo test -p wasm-bindgen-cli reference::runtest::test_14_empty_rs -- --nocapture
status14=$?

# Check if all reference tests passed
reference_status=0
for st in $status1 $status2 $status3 $status4 $status5 $status6 $status7 $status8 $status9 $status10 $status11 $status12 $status13 $status14; do
  if [ $st -ne 0 ]; then
    reference_status=1
  fi
done

# Overall test status - both must pass
if [ $externref_status -eq 0 ] && [ $reference_status -eq 0 ]; then
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
