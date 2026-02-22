#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "examples"
cp "/tests/examples/playwright.spec.ts" "examples/playwright.spec.ts"

# Install pnpm dependencies for examples workspace
cd examples
# Enable corepack for pnpm support
corepack enable
pnpm install

# Install playwright browsers (chrome is needed, not chromium, based on test config)
npx playwright install --with-deps chrome

# Build wasm-bindgen CLI (required by playwright tests)
cd ..
cargo build -p wasm-bindgen-cli --bin wasm-bindgen

# Build wasm-audio-worklet example (requires COOP/COEP headers to work)
cd examples/wasm-audio-worklet
pnpm install
pnpm run build
cd ..

# Create dist directory with the built example
mkdir -p dist/wasm-audio-worklet
cp -r wasm-audio-worklet/dist/* dist/wasm-audio-worklet/ 2>/dev/null || true

# Set PREBUILT_EXAMPLES so the test doesn't try to rebuild
export PREBUILT_EXAMPLES=1

# Run playwright test on the wasm-audio-worklet example (requires COOP/COEP headers)
npx playwright test playwright.spec.ts -g "wasm-audio-worklet"
test_status=$?
cd ..

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
