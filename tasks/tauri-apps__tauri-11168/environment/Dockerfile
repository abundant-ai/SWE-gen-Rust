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
    (git fetch --depth 1 origin 5886382204833a7135024de742f19d1ffe6e40d9 || git fetch --depth 1 origin "+refs/pull/11168/head:refs/remotes/origin/pr/11168") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1
ENV CARGO_PROFILE_DEV_DEBUG=0

# Fetch Rust dependencies
RUN cargo fetch

# Build the tauri-cli package
RUN cargo build --package tauri-cli

# Reset to clean state so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Enable pbxproj module compilation on Linux for testing
# The pbxproj module is normally macOS-only, but we need to test it on Linux
RUN sed -i 's/#\[cfg(target_os = "macos")\]/#\[cfg(any(target_os = "macos", test))\]/' crates/tauri-cli/src/helpers/mod.rs

# Clean and rebuild after applying bug.patch to ensure changes are picked up
RUN cargo clean --package tauri-cli
RUN cargo build --package tauri-cli

RUN rm -rf /app/src/.git

WORKDIR /app/src
