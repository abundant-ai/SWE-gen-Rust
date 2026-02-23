#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# The fix changes the iOS deployment target from 13.0 to 14.0
# Verify that all the default values have been updated to 14.0

# Check config.rs for the default value
if grep -q '"14.0".into()' crates/tauri-utils/src/config.rs; then
    config_check=0
else
    echo "FAIL: config.rs does not have the updated default value 14.0"
    config_check=1
fi

# Check schema files for the default value
if grep -q '"minimumSystemVersion": "14.0"' crates/tauri-cli/config.schema.json && \
   grep -q '"minimumSystemVersion": "14.0"' crates/tauri-schema-generator/schemas/config.schema.json; then
    schema_check=0
else
    echo "FAIL: Schema files do not have the updated default value 14.0"
    schema_check=1
fi

# Check template pbxproj for the deployment target
if grep -q 'IPHONEOS_DEPLOYMENT_TARGET = 14.0;' "crates/tauri-cli/templates/plugin/ios-xcode/tauri-plugin-{{ plugin_name }}.xcodeproj/project.pbxproj"; then
    template_check=0
else
    echo "FAIL: Template pbxproj does not have the updated deployment target 14.0"
    template_check=1
fi

# Overall test status
if [ $config_check -eq 0 ] && [ $schema_check -eq 0 ] && [ $template_check -eq 0 ]; then
    test_status=0
else
    test_status=1
fi

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
