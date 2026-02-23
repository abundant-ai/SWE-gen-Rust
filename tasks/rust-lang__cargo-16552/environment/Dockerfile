FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install additional system packages needed for Cargo tests
RUN apt-get update && apt-get install -y \
    libsecret-1-0 \
    libsecret-1-dev \
    pkg-config \
    libssl-dev \
    gcc-multilib \
    && rm -rf /var/lib/apt/lists/*

# Install cross-compilation target for i686
RUN rustup target add i686-unknown-linux-gnu


WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/cargo.git src && \
    cd src && \
    (git fetch --depth 1 origin 4071ddae4e160c430cae01c9d7fdabc9b35e6dfe || git fetch --depth 1 origin "+refs/pull/16552/head:refs/remotes/origin/pr/16552") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for tests
ENV CARGO_INCREMENTAL=0
ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build cargo (this is required for the test suite to work)
RUN cargo build

# Reset any changes from build artifacts
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for compiled languages)
RUN cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
