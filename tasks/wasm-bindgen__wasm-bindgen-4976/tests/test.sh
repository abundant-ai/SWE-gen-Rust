#!/bin/bash

cd /app/src

# TODO: Set environment variables if needed for tests
# Examples: CI=true, NODE_ENV=test, RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.bg.js" "crates/cli/tests/reference/anyref-import-catch.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/anyref-import-catch.wat" "crates/cli/tests/reference/anyref-import-catch.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-number.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.bg.js" "crates/cli/tests/reference/async-void.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/async-void.wat" "crates/cli/tests/reference/async-void.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.bg.js" "crates/cli/tests/reference/builder.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/builder.wat" "crates/cli/tests/reference/builder.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.bg.js" "crates/cli/tests/reference/closures.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/closures.wat" "crates/cli/tests/reference/closures.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.bg.js" "crates/cli/tests/reference/constructor.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/constructor.wat" "crates/cli/tests/reference/constructor.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.bg.js" "crates/cli/tests/reference/default-class.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/default-class.wat" "crates/cli/tests/reference/default-class.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/echo.bg.js" "crates/cli/tests/reference/echo.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/echo.wat" "crates/cli/tests/reference/echo.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/enums.bg.js" "crates/cli/tests/reference/enums.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/enums.wat" "crates/cli/tests/reference/enums.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.bg.js" "crates/cli/tests/reference/function-attrs.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/function-attrs.wat" "crates/cli/tests/reference/function-attrs.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/getter-setter.bg.js" "crates/cli/tests/reference/getter-setter.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/getter-setter.wat" "crates/cli/tests/reference/getter-setter.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-getter-setter.bg.js" "crates/cli/tests/reference/import-getter-setter.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-getter-setter.wat" "crates/cli/tests/reference/import-getter-setter.wat"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-bundler.bg.js" "crates/cli/tests/reference/import-target-bundler.bg.js"
mkdir -p "crates/cli/tests/reference"
cp "/tests/crates/cli/tests/reference/import-target-bundler.wat" "crates/cli/tests/reference/import-target-bundler.wat"

# CRITICAL: Run ONLY the specific test files from the PR, NOT the entire test suite!
# The test files to run are: "crates/cli/tests/reference/anyref-import-catch.bg.js" "crates/cli/tests/reference/anyref-import-catch.wat" "crates/cli/tests/reference/async-number.bg.js" "crates/cli/tests/reference/async-number.wat" "crates/cli/tests/reference/async-void.bg.js" # ... and 21 more
#
# TODO: Fill in the actual test command to run ONLY these specific files
#
# DO NOT run the entire test suite - it's too slow and may have unrelated failures!
#
# Examples for different languages/frameworks:
#
# Python (pytest with uv):
#   # If using uv venv at /opt/venv:
#   source /opt/venv/bin/activate
#   uv pip install -e . --no-deps 2>/dev/null || true  # Reinstall to pick up changes
#   pytest -xvs path/to/test_file.py
#   # Or without venv activation:
#   /opt/venv/bin/pytest -xvs path/to/test_file.py
#
# JavaScript/TypeScript (IMPORTANT: disable coverage thresholds when running subset!):
#   npx jest path/to/test.js path/to/test2.js --coverage=false
#   npx vitest run path/to/test.ts --coverage.enabled=false
#   npx mocha path/to/test.js path/to/test2.js
#   npx borp path/to/test.js --no-check-coverage   # Used by fastify, pino, etc.
#   npx tap path/to/test.js --no-check-coverage    # Node TAP framework
#   npx ava path/to/test.js                        # AVA framework
#
#   CRITICAL for JS/TS: DO NOT use "npm test" or "npm run test" without args!
#   These run the ENTIRE suite. Pass specific files via the test runner directly.
#   If you must use npm: npm run test -- path/to/test.js (note the -- separator)
#
# Go:
#   go test -v ./path/to/package/...
#   go test -v -run TestSpecificName ./...
#
# Rust:
#   cargo test --test test_name -- --nocapture
#   cargo test specific_test_name -- --nocapture
#
# Ruby (RSpec/Minitest):
#   bundle exec rspec path/to/spec.rb
#   bundle exec ruby -Itest path/to/test.rb
#
# Java (JUnit/Maven/Gradle):
#   mvn test -Dtest=TestClassName
#   gradle test --tests TestClassName

# TODO: Replace this placeholder with actual test command running ONLY the specific test files above
echo "ERROR: Test command not filled in! Must run specific test files, not entire suite." >&2
false
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
