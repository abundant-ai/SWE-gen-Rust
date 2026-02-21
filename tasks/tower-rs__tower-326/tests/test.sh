#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-retry/tests"
cp "/tests/tower-retry/tests/retry.rs" "tower-retry/tests/retry.rs"

# Patch the test to remove task::mock usage since it doesn't exist in tokio-test 0.2.0-alpha.4
# The original test uses task::mock which is only available in later versions
cat > tower-retry/tests/retry_patched.rs <<'TESTEOF'
use futures_util::{future, pin_mut};
use std::{future::Future, thread};
use tokio_test::{assert_pending, assert_ready_err, assert_ready_ok};
use tower_retry::Policy;
use tower_service::Service;
use tower_test::{assert_request_eq, mock};

#[tokio::test]
async fn retry_errors() {
    let (mut service, handle) = new_service(RetryErrors);

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle.as_mut(), "hello").send_error("retry me");
        assert_request_eq!(handle.as_mut(), "hello").send_response("world");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await.unwrap();
    assert_eq!(result, "world");

    th.join().unwrap();
}

#[tokio::test]
async fn retry_limit() {
    let (mut service, handle) = new_service(Limit(2));

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle.as_mut(), "hello").send_error("retry 1");
        assert_request_eq!(handle.as_mut(), "hello").send_error("retry 2");
        assert_request_eq!(handle.as_mut(), "hello").send_error("retry 3");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await;
    assert_eq!(result.unwrap_err().to_string(), "retry 3");

    th.join().unwrap();
}

#[tokio::test]
async fn retry_error_inspection() {
    let (mut service, handle) = new_service(UnlessErr("reject"));

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle.as_mut(), "hello").send_error("retry 1");
        assert_request_eq!(handle.as_mut(), "hello").send_error("reject");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await;
    assert_eq!(result.unwrap_err().to_string(), "reject");

    th.join().unwrap();
}

#[tokio::test]
async fn retry_cannot_clone_request() {
    let (mut service, handle) = new_service(CannotClone);

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle, "hello").send_error("retry 1");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await;
    assert_eq!(result.unwrap_err().to_string(), "retry 1");

    th.join().unwrap();
}

#[tokio::test]
async fn success_with_cannot_clone() {
    let (mut service, handle) = new_service(CannotClone);

    let th = thread::spawn(move || {
        pin_mut!(handle);
        assert_request_eq!(handle, "hello").send_response("world");
    });

    futures_util::future::poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
    let result = service.call("hello").await.unwrap();
    assert_eq!(result, "world");

    th.join().unwrap();
}

type Req = &'static str;
type Res = &'static str;
type InnerError = &'static str;
type Error = Box<dyn std::error::Error + Send + Sync>;
type Mock = mock::Mock<Req, Res>;
type Handle = mock::Handle<Req, Res>;

#[derive(Clone)]
struct RetryErrors;

impl Policy<Req, Res, Error> for RetryErrors {
    type Future = future::Ready<Self>;
    fn retry(&self, _: &Req, result: Result<&Res, &Error>) -> Option<Self::Future> {
        if result.is_err() {
            Some(future::ready(RetryErrors))
        } else {
            None
        }
    }

    fn clone_request(&self, req: &Req) -> Option<Req> {
        Some(*req)
    }
}

#[derive(Clone)]
struct Limit(usize);

impl Policy<Req, Res, Error> for Limit {
    type Future = future::Ready<Self>;
    fn retry(&self, _: &Req, result: Result<&Res, &Error>) -> Option<Self::Future> {
        if result.is_err() && self.0 > 0 {
            Some(future::ready(Limit(self.0 - 1)))
        } else {
            None
        }
    }

    fn clone_request(&self, req: &Req) -> Option<Req> {
        Some(*req)
    }
}

#[derive(Clone)]
struct UnlessErr(InnerError);

impl Policy<Req, Res, Error> for UnlessErr {
    type Future = future::Ready<Self>;
    fn retry(&self, _: &Req, result: Result<&Res, &Error>) -> Option<Self::Future> {
        result.err().and_then(|err| {
            if err.to_string() != self.0 {
                Some(future::ready(self.clone()))
            } else {
                None
            }
        })
    }

    fn clone_request(&self, req: &Req) -> Option<Req> {
        Some(*req)
    }
}

#[derive(Clone)]
struct CannotClone;

impl Policy<Req, Res, Error> for CannotClone {
    type Future = future::Ready<Self>;
    fn retry(&self, _: &Req, _: Result<&Res, &Error>) -> Option<Self::Future> {
        unreachable!("retry cannot be called since request isn't cloned");
    }

    fn clone_request(&self, _req: &Req) -> Option<Req> {
        None
    }
}

fn new_service<P: Policy<Req, Res, Error> + Clone>(
    policy: P,
) -> (tower_retry::Retry<P, Mock>, Handle) {
    let (service, handle) = mock::pair();
    let service = tower_retry::Retry::new(policy, service);
    (service, handle)
}
TESTEOF
mv tower-retry/tests/retry_patched.rs tower-retry/tests/retry.rs

# Update dependencies to enable tokio async test runtime
cat > tower-retry/Cargo.toml.new <<'EOF'
[package]
name = "tower-retry"
version = "0.3.0-alpha.1"
authors = ["Tower Maintainers <team@tower-rs.com>"]
license = "MIT"
readme = "README.md"
repository = "https://github.com/tower-rs/tower"
homepage = "https://github.com/tower-rs/tower"
documentation = "https://docs.rs/tower-retry/0.3.0-alpha.1"
description = """
Retry failed requests.
"""
categories = ["asynchronous", "network-programming"]
edition = "2018"

[dependencies]
tower-service = "0.3.0-alpha.1"
tower-layer = { version = "0.3.0-alpha.1", path = "../tower-layer" }
tokio-timer = "0.3.0-alpha.4"
pin-project = { version = "0.4.0-alpha.10", features = ["project_attr"] }
futures-core-preview = "0.3.0-alpha.18"

[dev-dependencies]
tower-test = { version = "0.3.0-alpha.1", path = "../tower-test" }
tokio-test = "0.2.0-alpha.4"
tokio = { version = "0.2", features = ["macros", "test-util"] }
futures-util-preview = "0.3.0-alpha.18"
EOF
mv tower-retry/Cargo.toml.new tower-retry/Cargo.toml

# Run the specific integration test for this PR
cargo test -p tower-retry --test retry -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
