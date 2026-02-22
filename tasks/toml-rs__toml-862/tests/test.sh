#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# This PR upgrades toml-test-harness and moves snapshot files from spec/ to spec-1.0.0/
# In BASE state: harness 1.0.0 expects files in spec/
# In HEAD state: harness 1.1.1 expects files in spec-1.0.0/

# Delete the old spec/ directory to force the test to look for spec-1.0.0/
# This makes BASE state fail (harness 1.0.0 can't find files in spec/)
rm -rf crates/toml_edit/tests/snapshots/invalid/spec

# Copy HEAD snapshot files to spec-1.0.0/ (where harness 1.1.1 expects them)
mkdir -p "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/inline-table-2-0.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/inline-table-2-0.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/inline-table-3-0.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/inline-table-3-0.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/key-value-pair-1.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/key-value-pair-1.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/keys-2.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/keys-2.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/string-4-0.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/string-4-0.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/string-7-0.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/string-7-0.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/table-9-0.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/table-9-0.stderr"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/table-9-1.stderr" "crates/toml_edit/tests/snapshots/invalid/spec-1.0.0/table-9-1.stderr"

# Run the decoder_compliance test
cargo test -p toml_edit --test decoder_compliance -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
