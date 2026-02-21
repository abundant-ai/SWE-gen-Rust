#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_adjacently_tagged.rs" "test_suite/tests/ui/default-attribute/incorrect_type_enum_adjacently_tagged.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_adjacently_tagged.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_enum_adjacently_tagged.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_externally_tagged.rs" "test_suite/tests/ui/default-attribute/incorrect_type_enum_externally_tagged.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_externally_tagged.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_enum_externally_tagged.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_internally_tagged.rs" "test_suite/tests/ui/default-attribute/incorrect_type_enum_internally_tagged.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_internally_tagged.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_enum_internally_tagged.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_untagged.rs" "test_suite/tests/ui/default-attribute/incorrect_type_enum_untagged.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_enum_untagged.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_enum_untagged.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_newtype.rs" "test_suite/tests/ui/default-attribute/incorrect_type_newtype.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_newtype.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_newtype.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_struct.rs" "test_suite/tests/ui/default-attribute/incorrect_type_struct.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_struct.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_struct.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_tuple.rs" "test_suite/tests/ui/default-attribute/incorrect_type_tuple.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/incorrect_type_tuple.stderr" "test_suite/tests/ui/default-attribute/incorrect_type_tuple.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/union.rs" "test_suite/tests/ui/default-attribute/union.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/union.stderr" "test_suite/tests/ui/default-attribute/union.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/union_path.rs" "test_suite/tests/ui/default-attribute/union_path.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/union_path.stderr" "test_suite/tests/ui/default-attribute/union_path.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/unit.rs" "test_suite/tests/ui/default-attribute/unit.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/unit.stderr" "test_suite/tests/ui/default-attribute/unit.stderr"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/unit_path.rs" "test_suite/tests/ui/default-attribute/unit_path.rs"
mkdir -p "test_suite/tests/ui/default-attribute"
cp "/tests/test_suite/tests/ui/default-attribute/unit_path.stderr" "test_suite/tests/ui/default-attribute/unit_path.stderr"
mkdir -p "test_suite/tests/ui/with"
cp "/tests/test_suite/tests/ui/with/incorrect_type.rs" "test_suite/tests/ui/with/incorrect_type.rs"
mkdir -p "test_suite/tests/ui/with"
cp "/tests/test_suite/tests/ui/with/incorrect_type.stderr" "test_suite/tests/ui/with/incorrect_type.stderr"

# Build serde_derive and check that the PR's changes were applied
cd /app/src/serde_derive
cargo build --release
if [ $? -ne 0 ]; then
    echo "serde_derive build failed"
    echo 0 > /logs/verifier/reward.txt
    exit 1
fi

# Check if the fix is applied by counting occurrences of the pattern
# With the fix (HEAD): Should have multiple occurrences (5)
# Without the fix (BASE with bug.patch): Should have 0 occurrences
count=$(grep -c "Default::Path(path) => .*quote_spanned!(path\.span()=>" /app/src/serde_derive/src/de.rs || echo "0")

if [ "$count" -ge "5" ]; then
    # FIX is applied - pattern found multiple times
    test_status=0
else
    # BUG is present - pattern not found or found less than expected
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
