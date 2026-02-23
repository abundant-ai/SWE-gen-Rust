#!/bin/bash

set -euo pipefail
cd /app/src

# Apply fix.patch to update dependencies
patch -p1 < /solution/fix.patch

# Restore deleted testsuite files from git
git checkout HEAD -- tests/testsuite/
