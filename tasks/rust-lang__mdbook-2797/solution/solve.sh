#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Rebuild after applying the patch (required for Rust)
cargo build --workspace --locked
