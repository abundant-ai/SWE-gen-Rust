FROM ubuntu:24.04

# Base system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

# Install rustfmt and rust-src components (required by rust-analyzer)
RUN rustup component add rust-src rustfmt

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/rust-analyzer.git src && \
    cd src && \
    (git fetch --depth 1 origin 3bd00dea465963ca229f431ffe5f0c9f0e4093e6 || git fetch --depth 1 origin "+refs/pull/21627/head:refs/remotes/origin/pr/21627") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV CI=1
ENV RUST_BACKTRACE=short
ENV CARGO_INCREMENTAL=0
ENV CARGO_NET_RETRY=10

# Fetch dependencies (downloads crates)
RUN cargo fetch

# Build the project
RUN cargo build --all-targets

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build --all-targets

RUN rm -rf /app/src/.git

WORKDIR /app/src
