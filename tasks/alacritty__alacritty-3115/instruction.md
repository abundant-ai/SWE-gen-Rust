The terminal grid is misreporting its size and scrollback history metrics after certain operations like resetting/clearing the grid. Specifically, the methods `Grid::len()` and `Grid::history_size()` can return values that do not reflect the grid’s actual visible lines and scrollback state.

This becomes observable when code relies on these values to validate the grid’s internal consistency across screen updates and resets: after a grid reset/clear sequence, `Grid::len()` should match the number of lines currently stored in the grid (the visible viewport plus any internal lines that are actually present), and `Grid::history_size()` should match the current amount of scrollback history retained. Currently, after reset-like operations, these values can remain stale or become inconsistent with the grid contents, causing downstream logic to behave as if lines/history exist when they do not (or vice versa).

Fix the grid bookkeeping so that:

- Calling `Grid::len()` always returns the correct current number of lines in the grid backing store.
- Calling `Grid::history_size()` always returns the correct current size of the scrollback/history region.
- After any grid reset/clear that is intended to discard history, `Grid::history_size()` must report 0, and `Grid::len()` must reflect only the active grid lines.
- After operations that preserve history, `Grid::history_size()` must remain accurate and `Grid::len()` must remain consistent with the combination of active grid lines and retained history (as represented internally).

The end result should be that grid state snapshots after various terminal actions (including selective erasure, clearing attributes like underline, and typical full-screen editor interactions) are consistent, and no scenario can produce a mismatch between the reported `len`/`history_size` and the actual stored grid contents.