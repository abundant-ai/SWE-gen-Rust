#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-hedge/tests"
cp "/tests/tower-hedge/tests/hedge.rs" "tower-hedge/tests/hedge.rs"

# Workaround: Update dependencies to versions compatible with the test file
# The original alpha versions from PR #334's HEAD don't work properly
# Use dependencies from commit e2f1a49 which has working tests
cat > tower-hedge/Cargo.toml.new <<'EOF'
[package]
name = "tower-hedge"
version = "0.3.0-alpha.1"
authors = ["Alex Leong <adlleong@gmail.com>"]
edition = "2018"
publish = false

[dependencies]
hdrhistogram = "6.0"
log = "0.4.1"
tower-service = "0.3.0-alpha.1"
tower-filter = { version = "0.3.0-alpha.1", path = "../tower-filter" }
tokio-timer = "0.3.0-alpha.4"
futures-util-preview = "0.3.0-alpha.18"
pin-project = "0.4.0-alpha.10"

[dev-dependencies]
tower-test = { version = "0.3.0-alpha.1", path = "../tower-test" }
tokio-test = "0.2"
tokio = { version = "0.2", features = ["macros", "test-util"] }
EOF
mv tower-hedge/Cargo.toml.new tower-hedge/Cargo.toml

# Run the specific integration test for this PR
# For Rust integration tests, the test name is the filename without .rs extension
cargo test -p tower-hedge --test hedge -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
