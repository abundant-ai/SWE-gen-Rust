FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/hyperium/hyper.git src && \
    cd src && \
    (git fetch --depth 1 origin 6ed70fde870b19504c4ca4a64ab37c559b6b0dd0 || git fetch --depth 1 origin "+refs/pull/3135/head:refs/remotes/origin/pr/3135") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build the project with full features (required for tests)
RUN cargo build --features full

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix support/mod.rs to avoid unused import error (StatusCode not used after bug.patch)
RUN sed -i 's/pub use hyper::{HeaderMap, StatusCode};/pub use hyper::HeaderMap; \/\/ StatusCode unused after bug.patch/' tests/support/mod.rs

# Rebuild after applying bug.patch
RUN cargo build --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
