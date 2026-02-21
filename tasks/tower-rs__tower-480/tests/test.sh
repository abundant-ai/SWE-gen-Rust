#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-test/tests"
cp "/tests/tower-test/tests/mock.rs" "tower-test/tests/mock.rs"
mkdir -p "tower/tests/balance"
cp "/tests/tower/tests/balance/main.rs" "tower/tests/balance/main.rs"
mkdir -p "tower/tests/buffer"
cp "/tests/tower/tests/buffer/main.rs" "tower/tests/buffer/main.rs"
mkdir -p "tower/tests"
cp "/tests/tower/tests/builder.rs" "tower/tests/builder.rs"
mkdir -p "tower/tests/filter"
cp "/tests/tower/tests/filter/main.rs" "tower/tests/filter/main.rs"
mkdir -p "tower/tests/hedge"
cp "/tests/tower/tests/hedge/main.rs" "tower/tests/hedge/main.rs"
mkdir -p "tower/tests/limit"
cp "/tests/tower/tests/limit/concurrency.rs" "tower/tests/limit/concurrency.rs"
mkdir -p "tower/tests/limit"
cp "/tests/tower/tests/limit/main.rs" "tower/tests/limit/main.rs"
mkdir -p "tower/tests/limit"
cp "/tests/tower/tests/limit/rate.rs" "tower/tests/limit/rate.rs"
mkdir -p "tower/tests/load_shed"
cp "/tests/tower/tests/load_shed/main.rs" "tower/tests/load_shed/main.rs"
mkdir -p "tower/tests/ready_cache"
cp "/tests/tower/tests/ready_cache/main.rs" "tower/tests/ready_cache/main.rs"
mkdir -p "tower/tests/retry"
cp "/tests/tower/tests/retry/main.rs" "tower/tests/retry/main.rs"
mkdir -p "tower/tests/spawn_ready"
cp "/tests/tower/tests/spawn_ready/main.rs" "tower/tests/spawn_ready/main.rs"
mkdir -p "tower/tests/steer"
cp "/tests/tower/tests/steer/main.rs" "tower/tests/steer/main.rs"
mkdir -p "tower/tests"
cp "/tests/tower/tests/support.rs" "tower/tests/support.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/call_all.rs" "tower/tests/util/call_all.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/main.rs" "tower/tests/util/main.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/oneshot.rs" "tower/tests/util/oneshot.rs"
mkdir -p "tower/tests/util"
cp "/tests/tower/tests/util/service_fn.rs" "tower/tests/util/service_fn.rs"

# Run the specific integration tests from this PR
# First run tower-test/tests/mock.rs
cargo test --package tower-test --all-features -- --nocapture
test_status=$?

# Then run the tower integration tests
if [ $test_status -eq 0 ]; then
  cargo test --test balance --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test buffer --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test builder --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test filter --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test hedge --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test limit --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test load_shed --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test ready_cache --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test retry --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test spawn_ready --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test steer --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  cargo test --test util --all-features -- --nocapture
  test_status=$?
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
