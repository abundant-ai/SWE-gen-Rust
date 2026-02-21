#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests"
cp "/tests/test_suite/tests/test_gen.rs" "test_suite/tests/test_gen.rs"

# Remove trybuild dependency to avoid compilation issues
sed -i '/trybuild/d; /automod/d; /rustversion/d' test_suite/Cargo.toml
rm -f test_suite/tests/compiletest.rs test_suite/tests/regression.rs

# Run clippy on the test file to catch the collection_is_never_read lint
# Allow other problematic lints that would cause false failures
cargo clippy -p serde_test_suite --tests -- \
  -D clippy::collection_is_never_read \
  -A clippy::repr_packed_without_abi \
  -A clippy::needless_lifetimes \
  -A clippy::question_mark
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
