`tree-sitter-highlight` currently only works correctly when the input source text is UTF-8. Tree-sitter itself can parse UTF-16 via `TSInputEncodingUTF16LE`, but attempting to highlight UTF-16 content (e.g., editor buffers that are UTF-16) fails or produces incorrect byte/offset handling because the highlighter path assumes UTF-8.

Add UTF-16 support to the highlighting pipeline so that highlighting works with UTF-16LE input without requiring callers to transcode the document to UTF-8.

The CLI should accept/propagate an explicit encoding choice (UTF-8 vs UTF-16LE) and use that encoding consistently when creating and running the highlighter. In particular:

- When running highlighting, the underlying input encoding passed through to Tree-sitter/highlighting must match the provided source buffer encoding.
- Token boundaries and returned highlighted ranges must correspond to the original input encoding so that consuming code (e.g., HTML rendering or iterating `HighlightEvent`s) slices the correct spans.
- The CLI’s `Encoding` enum must map 1:1 to the Tree-sitter FFI encoding constants (so converting between them is correct and stable), and passing UTF-16 should not require special-case conversions outside that mapping.

After the change, highlighting the same program text should produce the same sequence of `HighlightEvent`s and rendered output regardless of whether the input buffer is provided as UTF-8 bytes or as UTF-16LE bytes (with offsets interpreted in the appropriate units for that encoding).