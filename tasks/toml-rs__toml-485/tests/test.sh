#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder.rs" "crates/toml/tests/decoder.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/decoder_compliance.rs" "crates/toml/tests/decoder_compliance.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder.rs" "crates/toml/tests/encoder.rs"
mkdir -p "crates/toml/tests"
cp "/tests/crates/toml/tests/encoder_compliance.rs" "crates/toml/tests/encoder_compliance.rs"
mkdir -p "crates/toml/tests/testsuite"
cp "/tests/crates/toml/tests/testsuite/main.rs" "crates/toml/tests/testsuite/main.rs"

# Run the compliance tests and testsuite
# Note: decoder.rs and encoder.rs are test harnesses, not test files with #[test] functions
# The actual tests are in decoder_compliance, encoder_compliance, and testsuite

output1=$(cargo test -p toml --test decoder_compliance -- --nocapture 2>&1)
status1=$?
echo "$output1"

output2=$(cargo test -p toml --test encoder_compliance -- --nocapture 2>&1)
status2=$?
echo "$output2"

output3=$(cargo test -p toml --test testsuite -- --nocapture 2>&1)
status3=$?
echo "$output3"

# Check if tests actually ran (not just 0 tests filtered)
if echo "$output1" | grep -q "running 0 tests"; then
  echo "ERROR: No decoder_compliance tests ran in toml package." >&2
  status1=1
fi

if echo "$output2" | grep -q "running 0 tests"; then
  echo "ERROR: No encoder_compliance tests ran in toml package." >&2
  status2=1
fi

if echo "$output3" | grep -q "running 0 tests"; then
  echo "ERROR: No testsuite tests ran in toml package." >&2
  status3=1
fi

# All test files must pass
if [ $status1 -eq 0 ] && [ $status2 -eq 0 ] && [ $status3 -eq 0 ]; then
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
