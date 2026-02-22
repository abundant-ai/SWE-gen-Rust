#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Touch the Rust source that includes the templates to force rebuild
touch crates/mdbook-html/src/theme/mod.rs

# Rebuild after applying fix.patch to incorporate CSS/JS/template changes into the binary
# Do a full clean to ensure no caching issues with include_bytes!
cargo clean
cargo build --workspace --locked
cargo test --test gui --no-run --locked
