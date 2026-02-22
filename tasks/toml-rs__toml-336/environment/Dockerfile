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
    (git fetch --depth 1 origin 7f5472cdbefe535b8427733bf0eae20df6a2bc72 || git fetch --depth 1 origin "+refs/pull/336/head:refs/remotes/origin/pr/336") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for CI consistency
ENV RUST_BACKTRACE=1
ENV CARGO_TERM_COLOR=always

# Fetch dependencies
RUN cargo fetch

# Build the workspace to ensure everything compiles
RUN cargo build --workspace --all-targets

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Note: This PR is a merge that restructures the repository, so the workspace
# is in a broken state after applying bug.patch. We cannot build here.
# The test.sh script will build after copying the HEAD test files.

RUN rm -rf /app/src/.git

WORKDIR /app/src
