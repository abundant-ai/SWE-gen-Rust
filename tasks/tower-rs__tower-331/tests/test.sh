#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tower-filter/tests"
cp "/tests/tower-filter/tests/filter.rs" "tower-filter/tests/filter.rs"

# Patch the test to remove task::mock usage since it doesn't exist in tokio-test 0.2.0-alpha.4
# The original test uses task::mock which is only available in later versions
cat > tower-filter/tests/filter_patched.rs <<'TESTEOF'
use futures_util::{future::poll_fn, pin_mut};
use std::{future::Future, thread};
use tokio_test::{assert_ready_err};
use tower_filter::{error::Error, Filter};
use tower_service::Service;
use tower_test::{assert_request_eq, mock};

#[tokio::test]
async fn passthrough_sync() {
    let (mut service, handle) = new_service(|_| async { Ok(()) });

    let th = thread::spawn(move || {
        // Receive the requests and respond
        pin_mut!(handle);
        for i in 0..10 {
            assert_request_eq!(handle, format!("ping-{}", i)).send_response(format!("pong-{}", i));
        }
    });

    let mut responses = vec![];

    for i in 0usize..10 {
        let request = format!("ping-{}", i);
        poll_fn(|cx| service.poll_ready(cx)).await.unwrap();
        let exchange = service.call(request);
        let exchange = async move {
            let response = exchange.await.unwrap();
            let expect = format!("pong-{}", i);
            assert_eq!(response.as_str(), expect.as_str());
        };

        responses.push(exchange);
    }

    futures_util::future::join_all(responses).await;
    th.join().unwrap();
}

#[tokio::test]
async fn rejected_sync() {
    let (mut service, _handle) = new_service(|_| async { Err(Error::rejected()) });

    let result = service.call("hello".into()).await;
    assert!(result.is_err());
}

type Mock = mock::Mock<String, String>;
type Handle = mock::Handle<String, String>;

fn new_service<F, U>(f: F) -> (Filter<Mock, F>, Handle)
where
    F: Fn(&String) -> U,
    U: Future<Output = Result<(), Error>>,
{
    let (service, handle) = mock::pair();
    let service = Filter::new(service, f);
    (service, handle)
}
TESTEOF
mv tower-filter/tests/filter_patched.rs tower-filter/tests/filter.rs

# Update dependencies to enable tokio async test runtime
cat > tower-filter/Cargo.toml.new <<'EOF'
[package]
name = "tower-filter"
version = "0.3.0-alpha.1"
authors = ["Tower Maintainers <team@tower-rs.com>"]
license = "MIT"
readme = "README.md"
repository = "https://github.com/tower-rs/tower"
homepage = "https://github.com/tower-rs/tower"
documentation = "https://docs.rs/tower-filter/0.3.0-alpha.1"
description = """
Conditionally allow requests to be dispatched to a service based on the result
of a predicate.
"""
categories = ["asynchronous", "network-programming"]
edition = "2018"
publish = false

[dependencies]
tower-service = "0.3.0-alpha.1"
tower-layer = { version = "0.3.0-alpha.1", path = "../tower-layer" }
pin-project = { version = "0.4.0-alpha.10", features = ["project_attr"] }
futures-core-preview = "0.3.0-alpha.18"

[dev-dependencies]
tower-test = { version = "0.3.0-alpha.1", path = "../tower-test" }
tokio-test = "0.2"
tokio = { version = "0.2", features = ["macros", "test-util"] }
futures-util-preview = "0.3.0-alpha.18"
EOF
mv tower-filter/Cargo.toml.new tower-filter/Cargo.toml

# Run the specific integration test for this PR
cargo test -p tower-filter --test filter -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
