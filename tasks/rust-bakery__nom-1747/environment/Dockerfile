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
RUN git clone https://github.com/rust-bakery/nom.git src && \
    cd src && \
    (git fetch --depth 1 origin 0a14c5ae11ca03ba3e20f8130b74c0c723374f67 || git fetch --depth 1 origin "+refs/pull/1747/head:refs/remotes/origin/pr/1747") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV CARGO_INCREMENTAL=0
ENV CARGO_NET_RETRY=10

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build --verbose

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --verbose

RUN rm -rf /app/src/.git

WORKDIR /app/src
