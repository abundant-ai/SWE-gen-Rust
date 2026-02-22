// Test for PR #460: Dotted table header extending dotted key
// This test verifies that a dotted table header can extend an existing implicit table
// created by earlier dotted keys, which is valid TOML but was incorrectly rejected.

#[test]
fn test_dotted_table_extending_dotted_key() {
    // This is the exact TOML from the PR description that should parse successfully
    let toml_str = r#"
[tool.hatch]
version.source = "vcs"

[tool.hatch.version.raw-options]
local_scheme = "no-local-version"
"#;

    let result = toml_str.parse::<toml_edit::Document>();
    assert!(result.is_ok(), "Failed to parse valid TOML. This pattern should be allowed:\n\
        - [tool.hatch] creates the tool.hatch table\n\
        - version.source = \"vcs\" creates tool.hatch.version as an implicit table\n\
        - [tool.hatch.version.raw-options] should be allowed to extend that implicit table\n\
        Error: {:?}", result.err());
        
    if let Ok(doc) = result {
        // Verify the structure is correct
        let tool_hatch = &doc["tool"]["hatch"];
        assert!(tool_hatch.is_table());
        
        let version = &tool_hatch["version"];
        assert!(version.is_table());
        
        assert_eq!(version["source"].as_str(), Some("vcs"));
        assert_eq!(version["raw-options"]["local_scheme"].as_str(), Some("no-local-version"));
    }
}
