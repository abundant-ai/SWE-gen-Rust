After upgrading wasm-bindgen (regression reported between 0.2.106 and 0.2.107), projects that rely on wasm-bindgen’s CLI-generated JavaScript glue—especially those doing heavy in-browser builds and multi-threaded wasm usage—experience a significant performance degradation (about ~30% slower in a real-world browser bundler workload).

The CLI’s JavaScript code generation pipeline needs to be refactored so that the emitted entrypoints are more consistent and avoid unnecessary work/exports that can negatively impact downstream bundlers and runtime performance.

When generating JS bindings, the output should be assembled in a single, centralized “finalize” phase that produces consistent entrypoints for different targets:

- For standard bundler-style entrypoints, the generated JS entry module must:
  - Import the wasm module as `import * as wasm from "./<name>_bg.wasm";`
  - Call the initialization hook `__wbg_set_wasm(wasm)` imported from the generated JS glue module (the “bg” JS module)
  - Call `wasm.__wbindgen_start();` when appropriate
  - Re-export only the public API (e.g., `export { foo, ClassConstructor, add_i32 } from "./<name>_bg.js";`) and must not expose internal import shims or private helpers in the entrypoint exports.

- The generated entrypoints must include a TypeScript self-types directive at the very top so that runtimes like JSR/Deno can resolve the `.d.ts` for the JS entrypoint:
  - `/* @ts-self-types="./<name>.d.ts" */`

- For `--target experimental-nodejs-module`, the emitted output must be consolidated into a single JS entrypoint (it should not generate a separate `*_bg.js` entrypoint split that users must import separately). The resulting module should still expose only the public exports.

- For Node.js targets (CommonJS and ESM) and bundler targets, the entrypoints should only expose the public exports from the wasm-bindgen-generated bindings; internal glue used to set up wasm imports/exports must remain internal and should not be part of the public surface.

The goal is that upgrading between versions does not introduce a large runtime/performance regression for real applications due to changes in the shape/structure of the emitted JS. The generated JS should remain functionally correct (initialization via `__wbg_set_wasm`, start via `wasm.__wbindgen_start()` where applicable, correct re-exports), while producing consistent, minimal entrypoints across targets.