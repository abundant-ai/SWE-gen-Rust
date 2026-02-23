#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/tauri-cli/tests/fixtures/pbxproj"
cp "/tests/crates/tauri-cli/tests/fixtures/pbxproj/project.pbxproj" "crates/tauri-cli/tests/fixtures/pbxproj/project.pbxproj"
mkdir -p "crates/tauri-cli/tests/fixtures/pbxproj/snapshots"
cp "/tests/crates/tauri-cli/tests/fixtures/pbxproj/snapshots/tauri_cli__helpers__pbxproj__tests__project-modified.pbxproj.snap" "crates/tauri-cli/tests/fixtures/pbxproj/snapshots/tauri_cli__helpers__pbxproj__tests__project-modified.pbxproj.snap"
mkdir -p "crates/tauri-cli/tests/fixtures/pbxproj/snapshots"
cp "/tests/crates/tauri-cli/tests/fixtures/pbxproj/snapshots/tauri_cli__helpers__pbxproj__tests__project.pbxproj.snap" "crates/tauri-cli/tests/fixtures/pbxproj/snapshots/tauri_cli__helpers__pbxproj__tests__project.pbxproj.snap"

# Run the pbxproj tests in tauri-cli (parse and modify)
# These tests use snapshot testing and will fail if the parser can't handle underscores in IDs
cargo test --package tauri-cli --lib parse -- --nocapture && \
cargo test --package tauri-cli --lib modify -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
