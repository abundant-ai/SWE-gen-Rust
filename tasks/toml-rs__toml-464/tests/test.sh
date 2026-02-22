#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "crates/toml_edit/tests/testsuite"
cp "/tests/crates/toml_edit/tests/testsuite/serde.rs" "crates/toml_edit/tests/testsuite/serde.rs"

# Create a minimal main.rs that only includes the serde module (other tests removed to speed up)
cat > "crates/toml_edit/tests/testsuite/main.rs" << 'EOF'
#![recursion_limit = "256"]

mod serde;
EOF

# Run all serde tests in toml_edit (requires easy and serde features)
# Since we only copy serde.rs, this will only run tests from that file
output=$(cargo test -p toml_edit --test testsuite --features easy,serde -- --nocapture 2>&1)
test_status=$?
echo "$output"

# Check if tests actually ran (not just 0 tests filtered)
if echo "$output" | grep -q "running 0 tests"; then
  echo "ERROR: No tests ran in toml_edit testsuite." >&2
  test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
