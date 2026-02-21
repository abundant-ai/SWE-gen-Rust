#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tokio/src/runtime/tests"
cp "/tests/tokio/src/runtime/tests/queue.rs" "tokio/src/runtime/tests/queue.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_basic.rs" "tokio/tests/rt_basic.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_metrics.rs" "tokio/tests/rt_metrics.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_threaded.rs" "tokio/tests/rt_threaded.rs"
mkdir -p "tokio/tests"
cp "/tests/tokio/tests/rt_threaded_alt.rs" "tokio/tests/rt_threaded_alt.rs"

# Check if MetricAtomicU64 exists (fixed version) or if code uses AtomicU64 directly (buggy)
# In BASE (buggy): metric_atomics.rs doesn't exist
# IN HEAD (fixed): metric_atomics.rs exists
cd tokio
if [ ! -f "src/util/metric_atomics.rs" ]; then
    # Buggy version - metric_atomics.rs is missing
    echo "metric_atomics.rs not found - this is the buggy version"
    test_status=1
else
    # Fixed version - metric_atomics.rs exists, run the tests
    RUSTFLAGS='--cfg tokio_unstable' timeout 300 cargo test --lib 'runtime::tests::queue' --features full -- --nocapture
    test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
