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
    (git fetch --depth 1 origin 7e7fff10a644ee710f08a76fa1b11ced3a7c057d || git fetch --depth 1 origin "+refs/pull/3122/head:refs/remotes/origin/pr/3122") && \
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
RUN git apply --reject --whitespace=fix /tmp/bug.patch || true && rm /tmp/bug.patch
# Manually remove test files that the patch deletes (in case git apply failed on binary/control chars)
RUN rm -rf alacritty_terminal/tests/ref/clear_underline/

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --release

RUN rm -rf /app/src/.git

WORKDIR /app/src
