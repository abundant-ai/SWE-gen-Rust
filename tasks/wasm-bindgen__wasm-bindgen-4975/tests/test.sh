#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.js" "crates/cli/tests/reference/wasm-export-colon.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/wasm-export-colon.wat" "crates/cli/tests/reference/wasm-export-colon.wat"
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/Array.rs" "crates/js-sys/tests/wasm/Array.rs"
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/JSON.rs" "crates/js-sys/tests/wasm/JSON.rs"
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/Promise.rs" "crates/js-sys/tests/wasm/Promise.rs"
mkdir -p "crates/js-sys/tests/wasm"
cp "/tests/crates/js-sys/tests/wasm/Set.rs" "crates/js-sys/tests/wasm/Set.rs"
mkdir -p "crates/test/sample/src"
cp "/tests/crates/test/sample/src/lib.rs" "crates/test/sample/src/lib.rs"
mkdir -p "crates/test/src/rt"
cp "/tests/crates/test/src/rt/mod.rs" "crates/test/src/rt/mod.rs"
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.js" "tests/wasm/closures.js"
mkdir -p "tests/wasm"
cp "/tests/wasm/closures.rs" "tests/wasm/closures.rs"

# Run reference tests that have complete reference files in this PR
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_05_async_number_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_06_async_void_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_16_function_attrs_rs -- --nocapture && \
cargo test -p wasm-bindgen-cli --test wasm-bindgen reference::runtest::test_25_wasm_export_colon_rs -- --nocapture && \
cargo test -p js-sys --lib array -- --nocapture && \
cargo test -p js-sys --lib json -- --nocapture && \
cargo test -p js-sys --lib promise -- --nocapture && \
cargo test -p js-sys --lib set -- --nocapture && \
cargo test -p wasm-bindgen-test --lib -- --nocapture && \
cargo test --test wasm closures -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
