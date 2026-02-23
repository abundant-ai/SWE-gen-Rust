FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain (version 1.79 required by dependencies)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.79.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Linux system dependencies required by Tauri
RUN apt-get update && apt-get install -y \
    webkit2gtk-4.1 \
    libxdo-dev \
    libayatana-appindicator3-dev \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tauri-apps/tauri.git src && \
    cd src && \
    (git fetch --depth 1 origin 7a8e1511cfc70c37a6541bcf4a9f19d70f747abf || git fetch --depth 1 origin "+refs/pull/10840/head:refs/remotes/origin/pr/10840") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1
ENV CARGO_PROFILE_DEV_DEBUG=0

# Fetch Rust dependencies
RUN cargo fetch

# Build the tauri package to compile dependencies
RUN cargo build --package tauri

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Clean and rebuild after applying bug.patch to ensure changes are picked up
RUN cargo clean --package tauri
RUN cargo build --package tauri

RUN rm -rf /app/src/.git

WORKDIR /app/src
