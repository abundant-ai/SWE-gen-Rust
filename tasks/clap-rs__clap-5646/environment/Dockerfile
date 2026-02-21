FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages (shells needed for completion tests)
RUN apt-get update && apt-get install -y \
    bash \
    zsh \
    elvish \
    fish \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using version 1.92 for derive_ui tests)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/clap-rs/clap.git src && \
    cd src && \
    (git fetch --depth 1 origin f9a87bf1bf3dc75c450ad3173ae3423afc30c5d6 || git fetch --depth 1 origin "+refs/pull/5646/head:refs/remotes/origin/pr/5646") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never
ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Build examples and tests after applying bug.patch (tests depend on examples being built)
# In BASE state (without PowerShell support)
RUN cargo build --package clap_complete --tests --examples --features unstable-dynamic

RUN rm -rf /app/src/.git

WORKDIR /app/src
