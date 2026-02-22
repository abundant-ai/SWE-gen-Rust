#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/run-pass"
cp "/tests/run-pass/double_init_fail.rs" "tests/run-pass/double_init_fail.rs"

# Clean and rebuild the library to ensure we pick up any changes from Oracle agent
cargo clean 2>&1 >/dev/null
cargo build --lib 2>&1 || exit 1

# These are run-pass tests - compile and run them as executables
test_status=0
for test_file in "tests/run-pass/double_init_fail.rs"; do
  echo "Running test: $test_file"

  # Compile the test file as an executable
  rustc --edition 2018 \
    --extern rayon=target/debug/librayon.rlib \
    -L target/debug/deps \
    "$test_file" \
    -o "/tmp/$(basename $test_file .rs)" 2>&1

  compile_status=$?
  if [ $compile_status -ne 0 ]; then
    echo "ERROR: Failed to compile $test_file"
    test_status=1
    break
  fi

  # Run the compiled executable
  "/tmp/$(basename $test_file .rs)" 2>&1
  run_status=$?
  if [ $run_status -ne 0 ]; then
    echo "ERROR: Test $test_file failed with exit code $run_status"
    test_status=1
    break
  fi

  echo "PASS: $test_file"
done

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
