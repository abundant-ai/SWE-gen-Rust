#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui"
cp "/tests/gui/redirect.goml" "tests/gui/redirect.goml"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/redirects.rs" "tests/testsuite/redirects.rs"
mkdir -p "tests/testsuite/redirects/redirect_existing_page"
cp "/tests/testsuite/redirects/redirect_existing_page/book.toml" "tests/testsuite/redirects/redirect_existing_page/book.toml"
mkdir -p "tests/testsuite/redirects/redirect_existing_page/src"
cp "/tests/testsuite/redirects/redirect_existing_page/src/SUMMARY.md" "tests/testsuite/redirects/redirect_existing_page/src/SUMMARY.md"
mkdir -p "tests/testsuite/redirects/redirect_existing_page/src"
cp "/tests/testsuite/redirects/redirect_existing_page/src/chapter_1.md" "tests/testsuite/redirects/redirect_existing_page/src/chapter_1.md"
mkdir -p "tests/testsuite/redirects/redirect_removed_with_fragments_only"
cp "/tests/testsuite/redirects/redirect_removed_with_fragments_only/book.toml" "tests/testsuite/redirects/redirect_removed_with_fragments_only/book.toml"
mkdir -p "tests/testsuite/redirects/redirect_removed_with_fragments_only/src"
cp "/tests/testsuite/redirects/redirect_removed_with_fragments_only/src/SUMMARY.md" "tests/testsuite/redirects/redirect_removed_with_fragments_only/src/SUMMARY.md"
mkdir -p "tests/testsuite/redirects/redirect_removed_with_fragments_only/src"
cp "/tests/testsuite/redirects/redirect_removed_with_fragments_only/src/chapter_1.md" "tests/testsuite/redirects/redirect_removed_with_fragments_only/src/chapter_1.md"
mkdir -p "tests/testsuite/redirects/redirects_are_emitted_correctly"
cp "/tests/testsuite/redirects/redirects_are_emitted_correctly/book.toml" "tests/testsuite/redirects/redirects_are_emitted_correctly/book.toml"
mkdir -p "tests/testsuite/redirects/redirects_are_emitted_correctly/expected/nested"
cp "/tests/testsuite/redirects/redirects_are_emitted_correctly/expected/nested/page.html" "tests/testsuite/redirects/redirects_are_emitted_correctly/expected/nested/page.html"
mkdir -p "tests/testsuite/redirects/redirects_are_emitted_correctly/expected"
cp "/tests/testsuite/redirects/redirects_are_emitted_correctly/expected/overview.html" "tests/testsuite/redirects/redirects_are_emitted_correctly/expected/overview.html"
mkdir -p "tests/testsuite/redirects/redirects_are_emitted_correctly/src"
cp "/tests/testsuite/redirects/redirects_are_emitted_correctly/src/SUMMARY.md" "tests/testsuite/redirects/redirects_are_emitted_correctly/src/SUMMARY.md"
mkdir -p "tests/testsuite/redirects/redirects_are_emitted_correctly/src"
cp "/tests/testsuite/redirects/redirects_are_emitted_correctly/src/chapter_2.md" "tests/testsuite/redirects/redirects_are_emitted_correctly/src/chapter_2.md"

# Run the integration tests for redirects module
cargo test --test testsuite redirects -- --nocapture
testsuite_status=$?

# Run the GUI test for redirects
cargo test --test gui -- --nocapture
gui_status=$?

# Check if both tests passed
if [ $testsuite_status -eq 0 ] && [ $gui_status -eq 0 ]; then
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
