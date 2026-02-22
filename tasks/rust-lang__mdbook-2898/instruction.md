The header navigation rendering for page headings is incorrect when the document contains “unusual” heading levels (for example, jumping from an H2 to an H5, or having nested headings that don’t follow a strict incremental order). In these cases, the navigation tree in the header/summary panel should still produce a valid nested ordered-list structure that reflects the heading hierarchy without dropping items, mis-nesting them, or placing them under the wrong parent.

When viewing a page that includes headings like “Heading 3”, “Heading 2”, “Heading 5”, and “Heading 5.1” (with the levels not strictly increasing/decreasing by 1), the header navigation should render these headings as a nested sequence of <ol class="section"> elements containing <li class="header-item expanded"> entries, where each heading is represented by an <a> element with class "header-in-summary", and the currently active heading additionally has class "current-header".

Expected behavior:
- The navigation includes links to each heading anchor (e.g., href="#heading-3", "#heading-2", "#heading-5", "#heading-51").
- The nesting level of <ol class="section"> blocks corresponds to the heading levels even when levels are skipped.
- The “Heading 3” link is marked as the current header (class "header-in-summary current-header") when that section is active.
- “Heading 5” and “Heading 5.1” appear as children under “Heading 2” in the correct nested structure, not flattened to the wrong level and not attached to the wrong parent.

Actual behavior:
- For non-sequential heading levels, the header navigation DOM structure is malformed or incorrectly nested (for example: missing intermediate <ol> wrappers, headings rendered at the wrong depth, or the child headings not grouped under the expected parent), which causes the header navigation to display incorrectly and breaks DOM expectations for the summary structure.

Fix the header navigation generation so that it deterministically produces correct, well-formed HTML for heading trees with skipped levels, preserving the expected classes ("section", "header-item", "expanded", "chapter-link-wrapper", "header-in-summary", "current-header") and the correct parent/child grouping for headings.