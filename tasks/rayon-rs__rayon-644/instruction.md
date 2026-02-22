Rayon’s ParallelIterator currently propagates panics to the caller, but work on other threads may continue processing items for a while before the panic is observed. This can cause significantly more items to be processed than necessary after one item panics.

Add a new adaptor method `ParallelIterator::panic_fuse()` that wraps a parallel iterator such that, once any thread begins unwinding due to a panic in the iterator’s processing path, other threads stop processing additional items as soon as possible.

The intended behavior is:

- Calling `panic_fuse()` anywhere in a ParallelIterator chain should “fuse” the iterator so that a panic on one worker quickly halts processing on other workers.
- The fused iterator must still propagate the original panic to the caller (e.g., a panic with message "boom" should still be observed by the caller).
- Without `panic_fuse()`, it’s possible for an iterator like `(0..0x1_0000).into_par_iter().with_max_len(1).inspect(|i| if *i == 0xC000 { panic!("boom") })` to end up running the per-item closure for every other item besides the panicking one (i.e., processing `len-1` items).
- With `panic_fuse()`, the same pipeline must process strictly fewer than `len-1` items before the panic is observed, regardless of whether `panic_fuse()` is placed before or after an `inspect`-style adaptor.
- `panic_fuse()` must also work correctly when additional adaptors are applied afterward, including reversing the iteration order (e.g., `.panic_fuse().inspect(...).rev()` should also process strictly fewer than `len-1` items before propagating the panic).

Additionally, the new `panic_fuse()` adaptor must preserve expected trait behavior for parallel iterators:

- If the underlying iterator is `Clone`, the iterator returned by `panic_fuse()` must also be `Clone` and cloning it should produce an equivalent iterator (collecting from the clone and the original should yield the same results when no panic occurs).
- If the underlying iterator is `Debug`, the iterator returned by `panic_fuse()` must also be `Debug`.

The goal is to ensure `panic_fuse()` reliably reduces wasted work after a panic by synchronizing cancellation across threads, while remaining a normal, composable ParallelIterator adaptor.