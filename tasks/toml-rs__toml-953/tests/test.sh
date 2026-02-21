#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder.rs" "crates/toml/tests/decoder.rs"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/extending-table.stderr" "crates/toml/tests/snapshots/invalid/array/extending-table.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/missing-separator-02.stderr" "crates/toml/tests/snapshots/invalid/array/missing-separator-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-04.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-04.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-06.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-06.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-4.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-4.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-6.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-6.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-comma-02.stderr" "crates/toml/tests/snapshots/invalid/array/no-comma-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-comma-2.stderr" "crates/toml/tests/snapshots/invalid/array/no-comma-2.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/only-comma-02.stderr" "crates/toml/tests/snapshots/invalid/array/only-comma-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/only-comma-2.stderr" "crates/toml/tests/snapshots/invalid/array/only-comma-2.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/text-after-array-entries.stderr" "crates/toml/tests/snapshots/invalid/array/text-after-array-entries.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/text-before-array-separator.stderr" "crates/toml/tests/snapshots/invalid/array/text-before-array-separator.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/text-in-array.stderr" "crates/toml/tests/snapshots/invalid/array/text-in-array.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/bool"
cp "/tests/crates/toml/tests/snapshots/invalid/bool/mixed-case.stderr" "crates/toml/tests/snapshots/invalid/bool/mixed-case.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/control"
cp "/tests/crates/toml/tests/snapshots/invalid/control/only-ff.stderr" "crates/toml/tests/snapshots/invalid/control/only-ff.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/control"
cp "/tests/crates/toml/tests/snapshots/invalid/control/only-null.stderr" "crates/toml/tests/snapshots/invalid/control/only-null.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/control"
cp "/tests/crates/toml/tests/snapshots/invalid/control/only-vt.stderr" "crates/toml/tests/snapshots/invalid/control/only-vt.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/encoding"
cp "/tests/crates/toml/tests/snapshots/invalid/encoding/ideographic-space.stderr" "crates/toml/tests/snapshots/invalid/encoding/ideographic-space.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/encoding"
cp "/tests/crates/toml/tests/snapshots/invalid/encoding/utf16-comment.stderr" "crates/toml/tests/snapshots/invalid/encoding/utf16-comment.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/encoding"
cp "/tests/crates/toml/tests/snapshots/invalid/encoding/utf16-key.stderr" "crates/toml/tests/snapshots/invalid/encoding/utf16-key.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-minus.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-minus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-plus.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-plus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp.stderr"

# Run tests for the decoder test file which uses the snapshots
# Test file: crates/toml/tests/decoder.rs (which references all the .stderr snapshot files)
cargo test -p toml --test decoder
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
