#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Rebuild after applying the fix (Rust is a compiled language)
cargo build --locked
