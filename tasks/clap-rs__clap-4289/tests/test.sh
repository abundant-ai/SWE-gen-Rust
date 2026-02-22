#!/bin/bash

cd /app/src

export RUST_BACKTRACE=1
export CARGO_TERM_COLOR=never

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "clap_complete/tests"
cp "/tests/clap_complete/tests/common.rs" "clap_complete/tests/common.rs"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/aliases.bash" "clap_complete/tests/snapshots/aliases.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/basic.bash" "clap_complete/tests/snapshots/basic.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/feature_sample.bash" "clap_complete/tests/snapshots/feature_sample.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/quoting.bash" "clap_complete/tests/snapshots/quoting.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/special_commands.bash" "clap_complete/tests/snapshots/special_commands.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.bash" "clap_complete/tests/snapshots/sub_subcommands.bash"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/sub_subcommands.zsh" "clap_complete/tests/snapshots/sub_subcommands.zsh"
mkdir -p "clap_complete/tests/snapshots"
cp "/tests/clap_complete/tests/snapshots/value_hint.bash" "clap_complete/tests/snapshots/value_hint.bash"

# Run the clap_complete bash and zsh tests (which use the snapshot files)
cd clap_complete
cargo test --test bash --test zsh --no-fail-fast -- --nocapture
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
else
  echo 0 > /logs/verifier/reward.txt
fi
exit "$test_status"
