#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Fix trailing semicolon errors in client.rs macro (Rust compiler version issue)
sed -i 's/\$req_builder = \$req_builder\.header(\$name, \$val);/\$req_builder = \$req_builder.header(\$name, \$val)/' tests/client.rs

# Run the client test file
cargo test --test client -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
