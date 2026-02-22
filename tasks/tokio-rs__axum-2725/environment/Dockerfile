FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    pkg-config \
    libssl-dev \
    libpq-dev \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2025-09-28
ENV PATH="/root/.cargo/bin:${PATH}"

# Install older nightly for axum-macros (which has rust-toolchain file requiring nightly-2024-03-13)
RUN rustup toolchain install nightly-2024-03-13

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tokio-rs/axum.git src && \
    cd src && \
    (git fetch --depth 1 origin d4c90cbeb41612c5d0f9eee877151bbab0c450d1 || git fetch --depth 1 origin "+refs/pull/2725/head:refs/remotes/origin/pr/2725") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=always

# Fetch dependencies
RUN cargo fetch

# Build the project (build axum-macros which is needed for the tests)
RUN cargo build -p axum-macros

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (rebuild axum-macros)
RUN cargo build -p axum-macros

RUN rm -rf /app/src/.git

WORKDIR /app/src
