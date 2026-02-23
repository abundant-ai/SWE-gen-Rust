#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests/gui/books/heading-nav-folded"
cp "/tests/gui/books/heading-nav-folded/book.toml" "tests/gui/books/heading-nav-folded/book.toml"
mkdir -p "tests/gui/books/heading-nav-folded/src"
cp "/tests/gui/books/heading-nav-folded/src/SUMMARY.md" "tests/gui/books/heading-nav-folded/src/SUMMARY.md"
mkdir -p "tests/gui/books/heading-nav-folded/src"
cp "/tests/gui/books/heading-nav-folded/src/intro.md" "tests/gui/books/heading-nav-folded/src/intro.md"
mkdir -p "tests/gui/books/heading-nav-folded/src"
cp "/tests/gui/books/heading-nav-folded/src/next-main.md" "tests/gui/books/heading-nav-folded/src/next-main.md"
mkdir -p "tests/gui/books/heading-nav-folded/src/sub"
cp "/tests/gui/books/heading-nav-folded/src/sub/index.md" "tests/gui/books/heading-nav-folded/src/sub/index.md"
mkdir -p "tests/gui/books/heading-nav-folded/src/sub/inner"
cp "/tests/gui/books/heading-nav-folded/src/sub/inner/index.md" "tests/gui/books/heading-nav-folded/src/sub/inner/index.md"
mkdir -p "tests/gui/books/heading-nav-folded/src/sub"
cp "/tests/gui/books/heading-nav-folded/src/sub/second.md" "tests/gui/books/heading-nav-folded/src/sub/second.md"
mkdir -p "tests/gui/books/heading-nav/src"
cp "/tests/gui/books/heading-nav/src/SUMMARY.md" "tests/gui/books/heading-nav/src/SUMMARY.md"
mkdir -p "tests/gui/books/heading-nav/src"
cp "/tests/gui/books/heading-nav/src/unusual-heading-levels.md" "tests/gui/books/heading-nav/src/unusual-heading-levels.md"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-collapsed.goml" "tests/gui/heading-nav-collapsed.goml"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-folded.goml" "tests/gui/heading-nav-folded.goml"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-large-intro.goml" "tests/gui/heading-nav-large-intro.goml"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-markup.goml" "tests/gui/heading-nav-markup.goml"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-normal-intro.goml" "tests/gui/heading-nav-normal-intro.goml"
mkdir -p "tests/gui"
cp "/tests/gui/heading-nav-unusual-levels.goml" "tests/gui/heading-nav-unusual-levels.goml"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/index.rs" "tests/testsuite/index.rs"
mkdir -p "tests/testsuite"
cp "/tests/testsuite/toc.rs" "tests/testsuite/toc.rs"

# Run only the heading-nav GUI tests from this PR (filter by test name pattern)
cargo test --locked --test gui -- heading-nav
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
