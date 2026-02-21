#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/aliases.bash" "clap_complete/tests/snapshots/aliases.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/basic.bash" "clap_complete/tests/snapshots/basic.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/feature_sample.bash" "clap_complete/tests/snapshots/feature_sample.bash"
mkdir -p "clap_complete/tests/snapshots/home"
cp "/tests/clap_complete/tests/snapshots/home/.gitignore" "clap_complete/tests/snapshots/home/.gitignore"
mkdir -p "clap_complete/tests/snapshots/home/test/bash"
cp "/tests/clap_complete/tests/snapshots/home/test/bash/.bashrc" "clap_complete/tests/snapshots/home/test/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/test/elvish/elvish"
cp "/tests/clap_complete/tests/snapshots/home/test/elvish/elvish/rc.elv" "clap_complete/tests/snapshots/home/test/elvish/elvish/rc.elv"
mkdir -p "clap_complete/tests/snapshots/home/test/fish/fish/completions"
cp "/tests/clap_complete/tests/snapshots/home/test/fish/fish/completions/test.fish" "clap_complete/tests/snapshots/home/test/fish/fish/completions/test.fish"
mkdir -p "clap_complete/tests/snapshots/home/test/fish/fish"
cp "/tests/clap_complete/tests/snapshots/home/test/fish/fish/config.fish" "clap_complete/tests/snapshots/home/test/fish/fish/config.fish"
mkdir -p "clap_complete/tests/snapshots/home/test/zsh"
cp "/tests/clap_complete/tests/snapshots/home/test/zsh/.zshenv" "clap_complete/tests/snapshots/home/test/zsh/.zshenv"
mkdir -p "clap_complete/tests/snapshots/home/test/zsh/zsh"
cp "/tests/clap_complete/tests/snapshots/home/test/zsh/zsh/_test" "clap_complete/tests/snapshots/home/test/zsh/zsh/_test"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/quoting.bash" "clap_complete/tests/snapshots/quoting.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/special_commands.bash" "clap_complete/tests/snapshots/special_commands.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.bash" "clap_complete/tests/snapshots/sub_subcommands.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/subcommand_last.bash" "clap_complete/tests/snapshots/subcommand_last.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/two_multi_valued_arguments.bash" "clap_complete/tests/snapshots/two_multi_valued_arguments.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_hint.bash" "clap_complete/tests/snapshots/value_hint.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_terminator.bash" "clap_complete/tests/snapshots/value_terminator.bash"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/bash.rs" "clap_complete/tests/testsuite/bash.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/common.rs" "clap_complete/tests/testsuite/common.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/dynamic.rs" "clap_complete/tests/testsuite/dynamic.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/elvish.rs" "clap_complete/tests/testsuite/elvish.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/fish.rs" "clap_complete/tests/testsuite/fish.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/general.rs" "clap_complete/tests/testsuite/general.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/main.rs" "clap_complete/tests/testsuite/main.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/powershell.rs" "clap_complete/tests/testsuite/powershell.rs"
mkdir -p "clap_complete/tests/testsuite"
cp "/tests/clap_complete/tests/testsuite/zsh.rs" "clap_complete/tests/testsuite/zsh.rs"

# Run the specific tests from clap_complete package
output=$(cargo test --package clap_complete --no-fail-fast -- --nocapture 2>&1)
test_status=$?
echo "$output"

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
