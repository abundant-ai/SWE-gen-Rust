#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export RUSTFLAGS="--cfg tokio_unstable"

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_join.rs" "tokio/tests/macros_join.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/macros_select.rs" "tokio/tests/macros_select.rs"

# Rebuild the tokio package to pick up any changes from fix.patch
cd tokio
cargo build --features full
cd ..

# Run only the specific test files for this PR (macros_join and macros_select)
# These tests require the 'macros' feature
cd tokio
timeout 300 cargo test --test macros_join --features macros -- --nocapture
join_status=$?
timeout 300 cargo test --test macros_select --features macros -- --nocapture
select_status=$?

# Both tests must pass
if [ $join_status -eq 0 ] && [ $select_status -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
