#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests/compliance"
cp "/tests/crates/toml/tests/compliance/parse.rs" "crates/toml/tests/compliance/parse.rs"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-01.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-02.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-03.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-03.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-04.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-04.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-05.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-05.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-06.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-06.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-07.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-07.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-08.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-08.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr" "crates/toml/tests/snapshots/invalid/array/no-close-table-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/array"
cp "/tests/crates/toml/tests/snapshots/invalid/array/no-comma-03.stderr" "crates/toml/tests/snapshots/invalid/array/no-comma-03.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-close-01.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-close-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml/tests/snapshots/invalid/inline-table/no-close-02.stderr" "crates/toml/tests/snapshots/invalid/inline-table/no-close-02.stderr"
mkdir -p "crates/toml_edit/tests/compliance"
cp "/tests/crates/toml_edit/tests/compliance/parse.rs" "crates/toml_edit/tests/compliance/parse.rs"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-01.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-01.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-02.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-02.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-03.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-03.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-04.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-04.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-05.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-05.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-06.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-06.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-07.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-07.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-08.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-08.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-table-01.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-table-01.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-close-table-02.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-close-table-02.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/array"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/array/no-comma-03.stderr" "crates/toml_edit/tests/snapshots/invalid/array/no-comma-03.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/inline-table/no-close-01.stderr" "crates/toml_edit/tests/snapshots/invalid/inline-table/no-close-01.stderr"
mkdir -p "crates/toml_edit/tests/snapshots/invalid/inline-table"
cp "/tests/crates/toml_edit/tests/snapshots/invalid/inline-table/no-close-02.stderr" "crates/toml_edit/tests/snapshots/invalid/inline-table/no-close-02.stderr"

# Run the compliance tests that use the snapshot files
# These tests validate parsing behavior and error messages via snapshots
cargo test --test decoder_compliance -p toml && \
cargo test --test decoder_compliance -p toml_edit
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
