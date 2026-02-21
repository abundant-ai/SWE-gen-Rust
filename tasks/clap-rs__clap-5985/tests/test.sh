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
cp "/tests/clap_complete/tests/snapshots/custom_bin_name.bash" "clap_complete/tests/snapshots/custom_bin_name.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/feature_sample.bash" "clap_complete/tests/snapshots/feature_sample.bash"
mkdir -p "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/dynamic-env/exhaustive/bash/.bashrc"
mkdir -p "clap_complete/tests/snapshots/home/static/exhaustive/bash"
cp "/tests/clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc" "clap_complete/tests/snapshots/home/static/exhaustive/bash/.bashrc"
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

# Run the bash completion tests in clap_complete package
cargo test -p clap_complete --test testsuite -- bash --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
