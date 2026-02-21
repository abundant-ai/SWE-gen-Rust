#!/bin/bash

cd /app/src

# Set environment variables for tests
export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "alacritty_terminal/tests/ref/alt_reset"
cp "/tests/alacritty_terminal/tests/ref/alt_reset/grid.json" "alacritty_terminal/tests/ref/alt_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/clear_underline"
cp "/tests/alacritty_terminal/tests/ref/clear_underline/grid.json" "alacritty_terminal/tests/ref/clear_underline/grid.json"
mkdir -p "alacritty_terminal/tests/ref/colored_reset"
cp "/tests/alacritty_terminal/tests/ref/colored_reset/grid.json" "alacritty_terminal/tests/ref/colored_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/csi_rep"
cp "/tests/alacritty_terminal/tests/ref/csi_rep/grid.json" "alacritty_terminal/tests/ref/csi_rep/grid.json"
mkdir -p "alacritty_terminal/tests/ref/decaln_reset"
cp "/tests/alacritty_terminal/tests/ref/decaln_reset/grid.json" "alacritty_terminal/tests/ref/decaln_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/deccolm_reset"
cp "/tests/alacritty_terminal/tests/ref/deccolm_reset/grid.json" "alacritty_terminal/tests/ref/deccolm_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/delete_chars_reset"
cp "/tests/alacritty_terminal/tests/ref/delete_chars_reset/grid.json" "alacritty_terminal/tests/ref/delete_chars_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/delete_lines"
cp "/tests/alacritty_terminal/tests/ref/delete_lines/grid.json" "alacritty_terminal/tests/ref/delete_lines/grid.json"
mkdir -p "alacritty_terminal/tests/ref/erase_chars_reset"
cp "/tests/alacritty_terminal/tests/ref/erase_chars_reset/grid.json" "alacritty_terminal/tests/ref/erase_chars_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/fish_cc"
cp "/tests/alacritty_terminal/tests/ref/fish_cc/grid.json" "alacritty_terminal/tests/ref/fish_cc/grid.json"
mkdir -p "alacritty_terminal/tests/ref/grid_reset"
cp "/tests/alacritty_terminal/tests/ref/grid_reset/grid.json" "alacritty_terminal/tests/ref/grid_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/history"
cp "/tests/alacritty_terminal/tests/ref/history/grid.json" "alacritty_terminal/tests/ref/history/grid.json"
mkdir -p "alacritty_terminal/tests/ref/indexed_256_colors"
cp "/tests/alacritty_terminal/tests/ref/indexed_256_colors/grid.json" "alacritty_terminal/tests/ref/indexed_256_colors/grid.json"
mkdir -p "alacritty_terminal/tests/ref/insert_blank_reset"
cp "/tests/alacritty_terminal/tests/ref/insert_blank_reset/grid.json" "alacritty_terminal/tests/ref/insert_blank_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/issue_855"
cp "/tests/alacritty_terminal/tests/ref/issue_855/grid.json" "alacritty_terminal/tests/ref/issue_855/grid.json"
mkdir -p "alacritty_terminal/tests/ref/ll"
cp "/tests/alacritty_terminal/tests/ref/ll/grid.json" "alacritty_terminal/tests/ref/ll/grid.json"
mkdir -p "alacritty_terminal/tests/ref/newline_with_cursor_beyond_scroll_region"
cp "/tests/alacritty_terminal/tests/ref/newline_with_cursor_beyond_scroll_region/grid.json" "alacritty_terminal/tests/ref/newline_with_cursor_beyond_scroll_region/grid.json"
mkdir -p "alacritty_terminal/tests/ref/row_reset"
cp "/tests/alacritty_terminal/tests/ref/row_reset/grid.json" "alacritty_terminal/tests/ref/row_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/scroll_up_reset"
cp "/tests/alacritty_terminal/tests/ref/scroll_up_reset/grid.json" "alacritty_terminal/tests/ref/scroll_up_reset/grid.json"
mkdir -p "alacritty_terminal/tests/ref/selective_erasure"
cp "/tests/alacritty_terminal/tests/ref/selective_erasure/grid.json" "alacritty_terminal/tests/ref/selective_erasure/grid.json"
mkdir -p "alacritty_terminal/tests/ref/tab_rendering"
cp "/tests/alacritty_terminal/tests/ref/tab_rendering/grid.json" "alacritty_terminal/tests/ref/tab_rendering/grid.json"
mkdir -p "alacritty_terminal/tests/ref/tmux_git_log"
cp "/tests/alacritty_terminal/tests/ref/tmux_git_log/grid.json" "alacritty_terminal/tests/ref/tmux_git_log/grid.json"
mkdir -p "alacritty_terminal/tests/ref/tmux_htop"
cp "/tests/alacritty_terminal/tests/ref/tmux_htop/grid.json" "alacritty_terminal/tests/ref/tmux_htop/grid.json"
mkdir -p "alacritty_terminal/tests/ref/vim_24bitcolors_bce"
cp "/tests/alacritty_terminal/tests/ref/vim_24bitcolors_bce/grid.json" "alacritty_terminal/tests/ref/vim_24bitcolors_bce/grid.json"
mkdir -p "alacritty_terminal/tests/ref/vim_large_window_scroll"
cp "/tests/alacritty_terminal/tests/ref/vim_large_window_scroll/grid.json" "alacritty_terminal/tests/ref/vim_large_window_scroll/grid.json"
mkdir -p "alacritty_terminal/tests/ref/vim_simple_edit"
cp "/tests/alacritty_terminal/tests/ref/vim_simple_edit/grid.json" "alacritty_terminal/tests/ref/vim_simple_edit/grid.json"
mkdir -p "alacritty_terminal/tests/ref/vttest_cursor_movement_1"
cp "/tests/alacritty_terminal/tests/ref/vttest_cursor_movement_1/grid.json" "alacritty_terminal/tests/ref/vttest_cursor_movement_1/grid.json"

# Run the specific ref tests for this PR (all 27 test cases)
# Use a regex pattern to match all the test names
cargo test --package alacritty_terminal --test ref '^(alt_reset|clear_underline|colored_reset|csi_rep|decaln_reset|deccolm_reset|delete_chars_reset|delete_lines|erase_chars_reset|fish_cc|grid_reset|history|indexed_256_colors|insert_blank_reset|issue_855|ll|newline_with_cursor_beyond_scroll_region|row_reset|scroll_up_reset|selective_erasure|tab_rendering|tmux_git_log|tmux_htop|vim_24bitcolors_bce|vim_large_window_scroll|vim_simple_edit|vttest_cursor_movement_1)$' -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
