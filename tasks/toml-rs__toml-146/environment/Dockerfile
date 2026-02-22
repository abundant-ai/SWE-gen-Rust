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
    (git fetch --depth 1 origin bc52c14764c610155da48e092d5153764261db38 || git fetch --depth 1 origin "+refs/pull/146/head:refs/remotes/origin/pr/146") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for CI consistency
ENV RUST_BACKTRACE=1
ENV CARGO_TERM_COLOR=always

# Pin toml-test-harness to version from Sept 2021 to avoid newer test cases
# that expose unrelated bugs in this old codebase
RUN sed -i 's/toml-test-harness = "0.2"/toml-test-harness = "=0.2.0"/' Cargo.toml

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
# This prevents test failures unrelated to the actual PR #146 fix being tested
RUN sed -i '/debug_assert!(t.values_len() == 0);/d' src/parser/table.rs

# Rebuild after applying bug.patch and workaround
RUN cargo build --workspace --all-targets

RUN rm -rf /app/src/.git

WORKDIR /app/src
