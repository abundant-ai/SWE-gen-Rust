#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Rebuild after applying fix
cargo build --workspace --locked
