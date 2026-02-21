#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cap-lints warn"

# Fix dependency issue - update syn from 0.10 to 0.11 (0.10 no longer available)
sed -i 's/syn = { version = "0.10"/syn = { version = "0.11"/' serde_codegen/Cargo.toml
sed -i 's/syn = "0.10"/syn = "0.11"/' serde_codegen_internals/Cargo.toml
sed -i 's/serde_codegen_internals = { version = "=0.11.3"/serde_codegen_internals = { version = "=0.12.1"/' serde_codegen/Cargo.toml
sed -i 's/version = "0.11.3"/version = "0.12.1"/' serde_codegen_internals/Cargo.toml
sed -i 's/with-syntex/with-syn/g' testing/Cargo.toml
sed -i 's/default = \["with-syntex"\]/default = ["with-syn"]/' serde_codegen/Cargo.toml
sed -i 's/^build = "build.rs"/#build = "build.rs"/' testing/Cargo.toml
rm -f testing/build.rs

# Add serde_derive as a dev-dependency (after the [dev-dependencies] line)
sed -i '/^\[dev-dependencies\]/a serde_derive = { path = "../serde_derive" }' testing/Cargo.toml

# Update test.rs to directly include modules instead of generated code
cat > testing/tests/test.rs << 'EOF'
#![cfg_attr(feature = "clippy", feature(plugin))]
#![cfg_attr(feature = "clippy", plugin(clippy))]
#![cfg_attr(feature = "unstable-testing", feature(non_ascii_idents))]

#[macro_use]
extern crate serde_derive;
extern crate serde;
extern crate serde_test;

#[macro_use]
mod macros;

mod test_annotations;
mod test_bytes;
mod test_de;
mod test_gen;
mod test_macros;
mod test_ser;
EOF

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_annotations.rs" "testing/tests/test_annotations.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_bytes.rs" "testing/tests/test_bytes.rs"
mkdir -p "testing/tests"
cp "/tests/testing/tests/test_gen.rs" "testing/tests/test_gen.rs"

# Fix test files - remove deny(warnings) that causes issues with older Rust nightly
sed -i '/^#!\[deny(warnings)\]/d' testing/tests/test_annotations.rs
sed -i '/^#!\[deny(warnings)\]/d' testing/tests/test_bytes.rs
sed -i '/^#!\[deny(warnings)\]/d' testing/tests/test_gen.rs

# Run the specific test modules (test_annotations, test_bytes, test_gen)
cd testing
cargo test --test test -- test_annotations test_bytes test_gen
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
