FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (version 1.85.0 specified in Cargo.toml)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.85.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Install system dependencies required by Alacritty
RUN apt-get update && apt-get install -y \
    cmake \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/alacritty/alacritty.git src && \
    cd src && \
    (git fetch --depth 1 origin f0ed8222e55205565a1f6913890085ec02a97baf || git fetch --depth 1 origin "+refs/pull/5837/head:refs/remotes/origin/pr/5837") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variable from CI config
ENV CARGO_TERM_COLOR=always

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build --release

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --release

RUN rm -rf /app/src/.git

WORKDIR /app/src
