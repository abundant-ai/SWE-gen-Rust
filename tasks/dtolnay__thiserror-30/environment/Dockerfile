FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using nightly from early 2024 to match test expectations while meeting dependency requirements)
# Need 1.76+ for dependencies, but close enough to commit date for stable error messages
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2024-01-01
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/dtolnay/thiserror.git src && \
    cd src && \
    (git fetch --depth 1 origin f90fe75315c55bd3282505d7e4a3cda1cb56c098 || git fetch --depth 1 origin "+refs/pull/30/head:refs/remotes/origin/pr/30") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables from CI config
ENV RUSTFLAGS="-Dwarnings"

# Install rust-src component as required by rust-toolchain.toml
RUN rustup component add rust-src

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (clean first to ensure build.rs re-runs)
RUN cargo clean && cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
