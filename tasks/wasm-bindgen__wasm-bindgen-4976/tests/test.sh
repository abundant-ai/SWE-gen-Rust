#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.bg.js" "crates/cli/tests/reference/anyref-import-catch.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.wat" "crates/cli/tests/reference/anyref-import-catch.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.bg.js" "crates/cli/tests/reference/builder.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.wat" "crates/cli/tests/reference/builder.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.bg.js" "crates/cli/tests/reference/closures.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.bg.js" "crates/cli/tests/reference/constructor.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.wat" "crates/cli/tests/reference/constructor.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.bg.js" "crates/cli/tests/reference/default-class.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.wat" "crates/cli/tests/reference/default-class.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/echo.bg.js" "crates/cli/tests/reference/echo.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/echo.wat" "crates/cli/tests/reference/echo.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/enums.bg.js" "crates/cli/tests/reference/enums.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/enums.wat" "crates/cli/tests/reference/enums.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/getter-setter.bg.js" "crates/cli/tests/reference/getter-setter.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/getter-setter.wat" "crates/cli/tests/reference/getter-setter.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-getter-setter.bg.js" "crates/cli/tests/reference/import-getter-setter.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-getter-setter.wat" "crates/cli/tests/reference/import-getter-setter.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-bundler.bg.js" "crates/cli/tests/reference/import-target-bundler.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-bundler.wat" "crates/cli/tests/reference/import-target-bundler.wat"

# Run only the specific reference tests that have complete reference files in this PR
# Run each test individually since cargo test doesn't support multiple test names
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_03_anyref_import_catch_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_05_async_number_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_06_async_void_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_07_builder_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_08_closures_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_09_constructor_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_11_default_class_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_13_echo_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_15_enums_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_16_function_attrs_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_17_getter_setter_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_18_import_getter_setter_rs -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
