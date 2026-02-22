#!/bin/bash

set -euo pipefail
cd /app/src

# Apply fix patch (some hunks may fail due to rayon-demo being removed, which is OK)
patch -p1 < /solution/fix.patch || true

# Fix patch renames src/slice.rs to src/slice/mod.rs, but patch tool doesn't always delete the old file
# Remove src/slice.rs to avoid module ambiguity error (E0761)
rm -f src/slice.rs
