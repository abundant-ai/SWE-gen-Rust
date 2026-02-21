#!/bin/bash

set -euo pipefail
cd /app/src

patch -p1 < /solution/fix.patch

# fix.patch doesn't include build.rs fix, so we need to manually fix it
# to match the 2-parameter long_version signature restored by fix.patch
sed -i 's/long_version(githash)/long_version(githash, false)/g' build.rs
