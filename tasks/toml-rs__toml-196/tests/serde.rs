#![cfg(feature = "easy")]

use toml_edit::easy::Value;
use toml_edit::easy::Value::{Integer, Table};
use toml_edit::easy::map::Map;

#[test]
fn table_equality_should_be_order_independent() {
    let mut m1 = Map::new();
    m1.insert("a".to_string(), Integer(1));
    m1.insert("b".to_string(), Integer(2));

    let mut m2 = Map::new();
    m2.insert("b".to_string(), Integer(2));
    m2.insert("a".to_string(), Integer(1));

    assert_eq!(Table(m1), Table(m2));
}
