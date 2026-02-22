FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (MSRV is 1.76, but use stable for compatibility)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/toml-rs/toml.git src && \
    cd src && \
    (git fetch --depth 1 origin 1b9f3cb0aba26928d183a081727949fd8598f275 || git fetch --depth 1 origin "+refs/pull/70/head:refs/remotes/origin/pr/70") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for CI consistency
ENV RUST_BACKTRACE=1
ENV CARGO_TERM_COLOR=always

# Pin toml-test-harness to version from Sept 2021 to avoid newer test cases
# that expose unrelated bugs in this old codebase
RUN sed -i 's/toml-test-harness = "0.2"/toml-test-harness = "=0.2.0"/' Cargo.toml

# Fix lifetime annotation warnings that fail compilation with newer Rust
RUN sed -i "s/pub fn iter(&self) -> ArrayOfTablesIter {/pub fn iter(\&self) -> ArrayOfTablesIter<'_> {/" src/array_of_tables.rs && \
    sed -i "s/pub fn iter(&self) -> Iter {/pub fn iter(\&self) -> Iter<'_> {/" src/document.rs && \
    sed -i "119s/pub fn iter(&self) -> Iter {/pub fn iter(\&self) -> Iter<'_> {/" src/table.rs && \
    sed -i "368s/fn iter(&self) -> Iter;/fn iter(\&self) -> Iter<'_>;/" src/table.rs && \
    sed -i "383s/fn iter(&self) -> Iter {/fn iter(\&self) -> Iter<'_> {/" src/table.rs && \
    sed -i "98s/pub fn iter(&self) -> ArrayIter {/pub fn iter(\&self) -> ArrayIter<'_> {/" src/value.rs && \
    sed -i "168s/pub fn iter(&self) -> InlineTableIter {/pub fn iter(\&self) -> InlineTableIter<'_> {/" src/value.rs && \
    sed -i "238s/fn iter(&self) -> Iter {/fn iter(\&self) -> Iter<'_> {/" src/value.rs

# Fetch dependencies
RUN cargo fetch

# Build the workspace to ensure everything compiles
RUN cargo build --workspace --all-targets

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Apply workaround for unrelated bug (assertion in table.rs that was fixed in PR #166)
# This prevents test failures unrelated to the actual PR #70 fix being tested
RUN sed -i '/debug_assert!(t.values_len() == 0);/d' src/parser/table.rs

# Fix lifetime annotation warnings that fail compilation with newer Rust
RUN sed -i "s/pub fn iter(&self) -> ArrayOfTablesIter {/pub fn iter(\&self) -> ArrayOfTablesIter<'_> {/" src/array_of_tables.rs && \
    sed -i "s/pub fn iter(&self) -> Iter {/pub fn iter(\&self) -> Iter<'_> {/" src/document.rs && \
    sed -i "119s/pub fn iter(&self) -> Iter {/pub fn iter(\&self) -> Iter<'_> {/" src/table.rs && \
    sed -i "368s/fn iter(&self) -> Iter;/fn iter(\&self) -> Iter<'_>;/" src/table.rs && \
    sed -i "383s/fn iter(&self) -> Iter {/fn iter(\&self) -> Iter<'_> {/" src/table.rs && \
    sed -i "98s/pub fn iter(&self) -> ArrayIter {/pub fn iter(\&self) -> ArrayIter<'_> {/" src/value.rs && \
    sed -i "168s/pub fn iter(&self) -> InlineTableIter {/pub fn iter(\&self) -> InlineTableIter<'_> {/" src/value.rs && \
    sed -i "238s/fn iter(&self) -> Iter {/fn iter(\&self) -> Iter<'_> {/" src/value.rs

# Rebuild after applying bug.patch and workarounds
RUN cargo build --workspace --all-targets

RUN rm -rf /app/src/.git

WORKDIR /app/src
