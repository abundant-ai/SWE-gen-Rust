use tower_spawn_ready::SpawnReady;
use tower_test::mock;

#[tokio::test]
async fn spawn_ready_can_be_created() {
    let (service, _handle) = mock::pair::<(), ()>();
    let _service = SpawnReady::new(service);
    // If we got here without panicking, SpawnReady::new works
}
