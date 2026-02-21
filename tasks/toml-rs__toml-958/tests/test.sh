#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder.rs" "crates/toml/tests/decoder.rs"
mkdir -p "crates/toml/tests/fixtures/invalid/ext/integer"
cp "/tests/crates/toml/tests/fixtures/invalid/ext/integer/overflow-neg.toml" "crates/toml/tests/fixtures/invalid/ext/integer/overflow-neg.toml"
mkdir -p "crates/toml/tests/fixtures/invalid/ext/integer"
cp "/tests/crates/toml/tests/fixtures/invalid/ext/integer/overflow-pos.toml" "crates/toml/tests/fixtures/invalid/ext/integer/overflow-pos.toml"
mkdir -p "crates/toml/tests/serde"
cp "/tests/crates/toml/tests/serde/general.rs" "crates/toml/tests/serde/general.rs"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-minus.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-minus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-plus.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp-plus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-exp.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-exp.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/float"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/float/trailing-point-exp.stderr" "crates/toml/tests/snapshots/invalid/ext/float/trailing-point-exp.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/integer"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/integer/overflow-neg.stderr" "crates/toml/tests/snapshots/invalid/ext/integer/overflow-neg.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/ext/integer"
cp "/tests/crates/toml/tests/snapshots/invalid/ext/integer/overflow-pos.stderr" "crates/toml/tests/snapshots/invalid/ext/integer/overflow-pos.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/double-dot-01.stderr" "crates/toml/tests/snapshots/invalid/float/double-dot-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/double-dot-02.stderr" "crates/toml/tests/snapshots/invalid/float/double-dot-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/double-point-1.stderr" "crates/toml/tests/snapshots/invalid/float/double-point-1.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/double-point-2.stderr" "crates/toml/tests/snapshots/invalid/float/double-point-2.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-dot-01.stderr" "crates/toml/tests/snapshots/invalid/float/exp-dot-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-double-e-01.stderr" "crates/toml/tests/snapshots/invalid/float/exp-double-e-01.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-double-e-02.stderr" "crates/toml/tests/snapshots/invalid/float/exp-double-e-02.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-double-e-1.stderr" "crates/toml/tests/snapshots/invalid/float/exp-double-e-1.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-double-e-2.stderr" "crates/toml/tests/snapshots/invalid/float/exp-double-e-2.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/exp-point-1.stderr" "crates/toml/tests/snapshots/invalid/float/exp-point-1.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/trailing-exp-minus.stderr" "crates/toml/tests/snapshots/invalid/float/trailing-exp-minus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/trailing-exp-plus.stderr" "crates/toml/tests/snapshots/invalid/float/trailing-exp-plus.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/trailing-exp-point.stderr" "crates/toml/tests/snapshots/invalid/float/trailing-exp-point.stderr"
mkdir -p "crates/toml/tests/snapshots/invalid/float"
cp "/tests/crates/toml/tests/snapshots/invalid/float/trailing-exp.stderr" "crates/toml/tests/snapshots/invalid/float/trailing-exp.stderr"

# Run tests for the specific test files in the toml crate
# Test files: crates/toml/tests/decoder.rs and crates/toml/tests/serde/general.rs
# These correspond to the "decoder" and "serde" test targets
cargo test -p toml --features "parse,display" --test decoder --test serde
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
