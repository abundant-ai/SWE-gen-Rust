FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (commit from 2020, using Rust 1.52.1 for better crates.io compatibility)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.52.1
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
    (git fetch --depth 1 origin 403bd49df6a69105324ac3ae5f821c0905dc6daf || git fetch --depth 1 origin "+refs/pull/3421/head:refs/remotes/origin/pr/3421") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variable from CI config
ENV CARGO_TERM_COLOR=always

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build --release

# Reset git state before applying bug.patch
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --release

RUN rm -rf /app/src/.git

WORKDIR /app/src
