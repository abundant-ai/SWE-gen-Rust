#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/regression"
cp "/tests/test_suite/tests/regression/issue1904.rs" "test_suite/tests/regression/issue1904.rs"
mkdir -p "test_suite/tests/regression"
cp "/tests/test_suite/tests/regression/issue2565.rs" "test_suite/tests/regression/issue2565.rs"
mkdir -p "test_suite/tests/regression"
cp "/tests/test_suite/tests/regression/issue2792.rs" "test_suite/tests/regression/issue2792.rs"
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_annotations.rs" "test_suite/tests/test_annotations.rs"

# Remove trybuild dependency to avoid compilation issues
sed -i '/trybuild/d; /automod/d; /rustversion/d' test_suite/Cargo.toml
rm -f test_suite/tests/compiletest.rs

# Create a simple regression.rs that includes only our specific test files
cat > test_suite/tests/regression.rs << 'EOF'
#[path = "regression/issue1904.rs"]
mod issue1904;

#[path = "regression/issue2565.rs"]
mod issue2565;

#[path = "regression/issue2792.rs"]
mod issue2792;
EOF

# Run the regression tests (includes compile-time tests + runtime tests in issue2565)
cargo test --test regression -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
