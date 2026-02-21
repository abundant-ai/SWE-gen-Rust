#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Rebuild after applying fix.patch (Rust requires rebuild)
# The ui test uses trycmd which compiles examples, so we need to rebuild everything
cargo build --features help,usage,error-context --tests --examples
