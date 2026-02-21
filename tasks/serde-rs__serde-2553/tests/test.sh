#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/enum.stderr" "test_suite/tests/ui/default-attribute/enum.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/enum_path.stderr" "test_suite/tests/ui/default-attribute/enum_path.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/tuple_struct.rs" "test_suite/tests/ui/default-attribute/tuple_struct.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/tuple_struct.stderr" "test_suite/tests/ui/default-attribute/tuple_struct.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/tuple_struct_path.rs" "test_suite/tests/ui/default-attribute/tuple_struct_path.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/tuple_struct_path.stderr" "test_suite/tests/ui/default-attribute/tuple_struct_path.stderr"

# Build serde_derive and check that the PR's changes were applied
cd /app/src/serde_derive
cargo build --release
if [ $? -ne 0 ]; then
    echo "serde_derive build failed"
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Check if the fix is applied by looking for the expr_is_missing_seq function
# With the fix (HEAD): Should have the function definition with quote_spanned pattern
# Without the fix (BASE with bug.patch): Should not have this pattern
count=$(grep -c "quote_spanned!(path\.span()=> #assign_to #path())" /app/src/serde_derive/src/de.rs || echo "0")

if [ "$count" -ge "1" ]; then
    # FIX is applied - pattern found
    test_status=0
else
    # BUG is present - pattern not found
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
