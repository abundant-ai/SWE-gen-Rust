#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/doesnt_take_next.rs" "axum-macros/tests/debug_middleware/fail/doesnt_take_next.rs"
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/doesnt_take_next.stderr" "axum-macros/tests/debug_middleware/fail/doesnt_take_next.stderr"
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/next_not_last.rs" "axum-macros/tests/debug_middleware/fail/next_not_last.rs"
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/next_not_last.stderr" "axum-macros/tests/debug_middleware/fail/next_not_last.stderr"
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/takes_next_twice.rs" "axum-macros/tests/debug_middleware/fail/takes_next_twice.rs"
mkdir -p "axum-macros/tests/debug_middleware/fail"
cp "/tests/axum-macros/tests/debug_middleware/fail/takes_next_twice.stderr" "axum-macros/tests/debug_middleware/fail/takes_next_twice.stderr"
mkdir -p "axum-macros/tests/debug_middleware/pass"
cp "/tests/axum-macros/tests/debug_middleware/pass/basic.rs" "axum-macros/tests/debug_middleware/pass/basic.rs"

# Test if debug_middleware macro exists and works
# In BASE state (bug.patch applied): test function doesn't exist, should fail
# In HEAD state (fix applied): test function exists and tests should pass

# Check if the test function exists in the source
if grep -q "fn ui_debug_middleware" axum-macros/src/debug_handler.rs; then
    # Test function exists, run it
    cargo test -p axum-macros --lib ui_debug_middleware -- --nocapture
    test_status=$?
else
    # Test function doesn't exist (BASE state), fail
    echo "ui_debug_middleware test function not found - this is the BASE (buggy) state"
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
