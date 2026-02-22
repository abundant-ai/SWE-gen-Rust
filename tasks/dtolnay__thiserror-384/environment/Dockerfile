FROM ubuntu:24.04

# Base system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using nightly for UI tests)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/dtolnay/thiserror.git src && \
    cd src && \
    (git fetch --depth 1 origin 1d040f358a34d58139f1e1c12cec575319f16edf || git fetch --depth 1 origin "+refs/pull/384/head:refs/remotes/origin/pr/384") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables from CI config
ENV RUSTFLAGS="-Dwarnings -Amismatched-lifetime-syntaxes"

# Install rust-src component as required by rust-toolchain.toml
RUN rustup component add rust-src

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build

# Reset to ensure bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
