#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Build the library first
cargo build --lib 2>&1 || exit 1

# Create a simple test program that uses interleave_shortest
cat > /tmp/test_interleave_shortest.rs << 'EOF'
extern crate rayon;
use rayon::prelude::*;

fn main() {
    let (x, y) = (vec![1, 2, 3, 4], vec![5, 6]);
    let r: Vec<i32> = x.into_par_iter().interleave_shortest(y).collect();
    assert_eq!(r, vec![1, 5, 2, 6, 3]);
    println!("Test passed!");
}
EOF

# Try to compile and run the test
# In BASE state: interleave_shortest doesn't exist, so compilation fails
# In HEAD state: interleave_shortest exists, so compilation and execution succeed
rustc --edition 2018 \
  --extern rayon=target/debug/librayon.rlib \
  -L target/debug/deps \
  /tmp/test_interleave_shortest.rs \
  -o /tmp/test_binary 2>&1

compile_status=$?

if [ $compile_status -eq 0 ]; then
  # Compilation succeeded, now run the test
  /tmp/test_binary
  test_status=$?
else
  # Compilation failed
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
