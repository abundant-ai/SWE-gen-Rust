FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (project requires Rust 1.85)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.85.0
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/BurntSushi/ripgrep.git src && \
    cd src && \
    (git fetch --depth 1 origin 01c4ba9fd8d41b7a15434c604c1a801afc5e0c34 || git fetch --depth 1 origin "+refs/pull/1516/head:refs/remotes/origin/pr/1516") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build the project and tests
RUN cargo build --tests

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix build.rs to match the reverted app.rs signature (1 parameter)
# bug.patch changes long_version to 1 param but doesn't update all call sites
RUN sed -i 's/long_version(githash, false)/long_version(githash)/g' build.rs

# Rebuild after applying bug.patch
RUN cargo build --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
