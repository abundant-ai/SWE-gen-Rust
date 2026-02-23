FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

# Install rustup-toolchain-install-master for pinned rustc
RUN cargo install rustup-toolchain-install-master@1.6.0

# Install pinned rustc commit (required for proc-macro internals stability)
RUN rustup-toolchain-install-master 548e586795f6b6fe089d8329aa5edbf0f5202646 -c cargo -c rust-src -c rustfmt && \
    rustup default 548e586795f6b6fe089d8329aa5edbf0f5202646

# Emulate nightly toolchain
ENV RUSTC_BOOTSTRAP=1

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/rust-analyzer.git src && \
    cd src && \
    git config core.autocrlf false && \
    (git fetch --depth 1 origin 7a48463c09e02b989c4b348ca3f554598400574f || git fetch --depth 1 origin "+refs/pull/21399/head:refs/remotes/origin/pr/21399") && \
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
RUN git apply --ignore-whitespace /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build --all-targets

RUN rm -rf /app/src/.git

WORKDIR /app/src
