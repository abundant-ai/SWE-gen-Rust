#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-load-shed/tests"
cp "/tests/tower-load-shed/tests/load-shed.rs" "tower-load-shed/tests/load-shed.rs"

# Patch the test to remove task::mock usage since it doesn't exist in tokio-test 0.2.0-alpha.4
# The original test uses task::mock which is only available in later versions
cat > tower-load-shed/tests/load-shed_patched.rs <<'TESTEOF'
use futures_util::pin_mut;
use std::{future::Future, task::Poll, thread};
use tokio_test::{assert_ready_err, assert_ready_ok};
use tower_load_shed::{self, LoadShed};
use tower_service::Service;
use tower_test::{assert_request_eq, mock};

#[tokio::test]
async fn when_ready() {
    let (mut service, handle) = new_service();

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle, "hello").send_response("world");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await.unwrap();
    assert_eq!(result, "world");

    th.join().unwrap();
}

#[tokio::test]
async fn when_not_ready() {
    let (mut service, mut handle) = new_service();

    handle.allow(0);

    // Service should always report ready (that's the load shedding behavior)
    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();

    // But the call should fail with Overloaded error because inner service is not ready
    let fut = service.call("hello");
    pin_mut!(fut);

    let result = futures_util::future::poll_fn(|cx| match fut.as_mut().poll(cx) {
        Poll::Ready(r) => Poll::Ready(r),
        Poll::Pending => Poll::Pending,
    }).await;

    assert!(result.is_err());
    assert!(result.unwrap_err().is::<tower_load_shed::error::Overloaded>());
}

type Mock = mock::Mock<&'static str, &'static str>;
type Handle = mock::Handle<&'static str, &'static str>;

fn new_service() -> (LoadShed<Mock>, Handle) {
    let (service, handle) = mock::pair();
    let service = LoadShed::new(service);
    (service, handle)
}
TESTEOF
mv tower-load-shed/tests/load-shed_patched.rs tower-load-shed/tests/load-shed.rs

# Update dependencies to enable tokio async test runtime
cat > tower-load-shed/Cargo.toml.new <<'EOF'
[package]
name = "tower-load-shed"
version = "0.3.0-alpha.1"
authors = ["Tower Maintainers <team@tower-rs.com>"]
license = "MIT"
readme = "README.md"
repository = "https://github.com/tower-rs/tower"
homepage = "https://github.com/tower-rs/tower"
documentation = "https://docs.rs/tower-load-shed/0.3.0-alpha.1"
description = """
Middleware for shedding load when inner services aren't ready.
"""
categories = ["asynchronous", "network-programming"]
edition = "2018"

[dependencies]
tower-service = "0.3.0-alpha.1"
tower-layer = { version = "0.3.0-alpha.1", path = "../tower-layer" }
futures-core-preview = "0.3.0-alpha.18"
pin-project = { version = "0.4.0-alpha.10", features = ["project_attr"] }

[dev-dependencies]
tower-test = { version = "0.3.0-alpha.1", path = "../tower-test" }
tokio-test = "0.2.0-alpha.4"
tokio = { version = "0.2", features = ["macros", "test-util"] }
futures-util-preview = "0.3.0-alpha.18"
EOF
mv tower-load-shed/Cargo.toml.new tower-load-shed/Cargo.toml

# Run the specific integration test for this PR
cargo test -p tower-load-shed --test load-shed -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
