#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_mangen/tests/snapshots"
cp "/tests/clap_mangen/tests/snapshots/help_headings.bash.roff" "clap_mangen/tests/snapshots/help_headings.bash.roff"
mkdir -p "clap_mangen/tests/testsuite"
cp "/tests/clap_mangen/tests/testsuite/common.rs" "clap_mangen/tests/testsuite/common.rs"
mkdir -p "clap_mangen/tests/testsuite"
cp "/tests/clap_mangen/tests/testsuite/roff.rs" "clap_mangen/tests/testsuite/roff.rs"

# Run specific tests from the modified test files
# Tests are in: clap_mangen package (testsuite test target includes roff.rs and common.rs)
cargo test -p clap_mangen --test testsuite -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
