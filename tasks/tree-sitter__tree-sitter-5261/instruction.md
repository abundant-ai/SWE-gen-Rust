When using Tree-sitter’s WebAssembly language support (e.g., loading a WASM grammar and parsing with a `Parser` using a `WasmStore`), some WASM modules can fail nondeterministically with runtime traps such as `indirect call type mismatch`, `uninitialized element`, `out of bounds memory access`, or `unreachable`. This has been observed when building and running WASM plugins on wasm32 targets (notably Rust-produced wasm32-unknown-unknown) and can reproduce during normal parsing/initialization rather than only in synthetic stress tests.

The underlying issue is incorrect behavior in the Tree-sitter WASM stdlib allocator, specifically `realloc` (and related edge cases in `calloc`). The allocator must conform to standard C allocation semantics closely enough to avoid corrupting memory or triggering traps when a guest WASM language/external scanner performs allocations and resizes buffers.

Fix the WASM stdlib memory functions so the following behaviors are guaranteed:

- `realloc(ptr, 0)` must behave like freeing `ptr` and returning `NULL`.
- If `realloc` cannot allocate the new region (i.e., the internal `malloc` for the new size fails), it must return `NULL` and must not attempt to copy memory into a null destination.
- When `realloc` succeeds, it must copy data from the old region into the new region only up to the new region’s size (i.e., `min(old_size, new_size)`), to avoid reading/writing out of bounds.
- After a successful `realloc`, the old region must be freed so the heap does not leak and does not retain stale bookkeeping that can later corrupt allocations.
- `calloc(nmemb, size)` must return `NULL` if the underlying `malloc` fails (and should not proceed to zero memory or otherwise operate on a null pointer).

A concrete scenario that must no longer crash: an external scanner (running inside the WASM language) allocates a very large block, allocates a small second block, then shrinks the large block with `realloc` down to a tiny size, and then frees both allocations. This sequence must complete without WASM traps and without corrupting subsequent allocations.

After these fixes, loading and running multiple existing WASM grammars via `WasmStore::load_language`, setting the resulting language on a `Parser`, and parsing typical inputs should run reliably without intermittent WASM runtime errors.