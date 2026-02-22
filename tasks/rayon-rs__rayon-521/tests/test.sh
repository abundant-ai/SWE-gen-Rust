#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/compile-fail"
cp "/tests/compile-fail/cannot_collect_filtermap_data.rs" "tests/compile-fail/cannot_collect_filtermap_data.rs"
mkdir -p "tests/compile-fail"
cp "/tests/compile-fail/rc_par_iter.rs" "tests/compile-fail/rc_par_iter.rs"

# Create a simple test to verify collect_into_vec works for indexed iterators
# At HEAD: collect_into_vec should exist and work
# At BASE: collect_into should exist, collect_into_vec should not exist

# Build the library
cargo build --lib --release 2>&1 > /dev/null

# Create a test program that uses collect_into_vec
cat > /tmp/test_collect.rs << 'EOF'
extern crate rayon;
use rayon::prelude::*;

fn main() {
    let a: Vec<i32> = (0..10).collect();
    let mut b = vec![];
    a.par_iter().map(|&i| i + 1).collect_into_vec(&mut b);
    assert_eq!(b.len(), 10);
    println!("collect_into_vec works!");
}
EOF

# Try to compile and run the test
rustc --edition=2015 \
  -L target/release/deps \
  --extern rayon=target/release/librayon.rlib \
  /tmp/test_collect.rs \
  -o /tmp/test_collect 2>&1

# If it compiled successfully, run it
if [ -f /tmp/test_collect ]; then
  /tmp/test_collect
  test_status=$?
  echo "Test program executed successfully"
else
  echo "Test program failed to compile (expected at BASE)"
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
