FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using nightly from early 2024 to support modern dependencies)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2024-01-01
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/dtolnay/thiserror.git src && \
    cd src && \
    (git fetch --depth 1 origin aa123cfe0cafca605eac78ba35ece9e9e656a9ec || git fetch --depth 1 origin "+refs/pull/25/head:refs/remotes/origin/pr/25") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables from CI config
ENV RUSTFLAGS="-Dwarnings"

# Fetch dependencies
RUN cargo fetch

# Build the project
RUN cargo build

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (clean first to ensure build.rs re-runs)
RUN cargo clean && cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
