#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# Rebuild the library after applying the fix
cargo build --features full
