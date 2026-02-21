use std::time::Duration;
use tower_hedge::{Hedge, Policy};
use tower_service::Service;
use tower_test::mock;

type Req = &'static str;
type Res = &'static str;

#[derive(Clone)]
struct TestPolicy;

impl tower_hedge::Policy<Req> for TestPolicy {
    fn can_retry(&self, _req: &Req) -> bool {
        true
    }

    fn clone_request(&self, req: &Req) -> Option<Req> {
        Some(req)
    }
}

#[tokio::test]
async fn hedge_basic_test() {
    // Just test that Hedge can be created and service works
    let (service, _handle) = tower_test::mock::pair::<Req, Res>();
    let _service = Hedge::new(
        service,
        TestPolicy,
        10,
        0.9,
        Duration::from_secs(60),
    );
    // If we got here without panicking, the basic structure works
}
