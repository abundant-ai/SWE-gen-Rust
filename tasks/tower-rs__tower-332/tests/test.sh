#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-spawn-ready/tests"
cp "/tests/tower-spawn-ready/tests/spawn_ready.rs" "tower-spawn-ready/tests/spawn_ready.rs"

# Update dependencies to enable tokio async test runtime
cat > tower-spawn-ready/Cargo.toml.new <<'EOF'
[package]
name = "tower-spawn-ready"
version = "0.3.0-alpha.1"
authors = ["Tower Maintainers <team@tower-rs.com>"]
license = "MIT"
readme = "README.md"
repository = "https://github.com/tower-rs/tower"
homepage = "https://github.com/tower-rs/tower"
documentation = "https://docs.rs/tower-spawn-ready/0.3.0-alpha.1"
description = """
Drives service readiness via a spawned task
"""
categories = ["asynchronous", "network-programming"]
edition = "2018"
publish = false

[dependencies]
futures-core-preview = "0.3.0-alpha.18"
futures-util-preview = "0.3.0-alpha.18"
pin-project = "0.4.0-alpha.10"
tower-service = "0.3.0-alpha.1"
tower-layer = { version = "0.3.0-alpha.1", path = "../tower-layer" }
tower-util = { version = "0.3.0-alpha.1", path = "../tower-util" }
tokio-executor = "0.2.0-alpha.4"
tokio-sync = "0.2.0-alpha.4"

[dev-dependencies]
tower-test = { version = "0.3.0-alpha.1", path = "../tower-test" }
tokio-test = "0.2"
tokio = { version = "0.2", features = ["macros", "test-util"] }
EOF
mv tower-spawn-ready/Cargo.toml.new tower-spawn-ready/Cargo.toml

# Run the specific integration test for this PR
cargo test -p tower-spawn-ready --test spawn_ready -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
