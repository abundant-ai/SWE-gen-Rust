use thiserror::Error;

// Test that Option<Error> works for source fields
#[derive(Error, Debug)]
#[error("test error")]
pub struct OptSourceNoBacktrace {
    #[source]
    source: Option<anyhow::Error>,
}

#[derive(Error, Debug)]
pub enum OptSourceEnum {
    #[error("test variant")]
    Test {
        #[source]
        source: Option<anyhow::Error>,
    },
}

#[test]
fn test_option() {
    // Just test that the types compile
    let _: Option<OptSourceNoBacktrace> = None;
    let _: Option<OptSourceEnum> = None;
}
