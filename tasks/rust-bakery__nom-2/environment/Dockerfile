FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (use nightly from March 2015 to match commit date)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2015-03-01
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-bakery/nom.git src && \
    cd src && \
    (git fetch --depth 1 origin d2006d3c592c186b038671b6c0aae608607e43f8 || git fetch --depth 1 origin "+refs/pull/2/head:refs/remotes/origin/pr/2") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV CARGO_INCREMENTAL=0
ENV CARGO_NET_RETRY=10
ENV RUSTFLAGS="-A deprecated -A useless_deprecated -A semicolon_in_expressions_from_macros"

# Fetch dependencies
RUN cargo fetch

# Build the project (may fail if HEAD has compilation errors, that's ok)
RUN cargo build --verbose || true

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix missing slice_patterns feature gate (bug in repo at this commit)
RUN sed -i 's/#!\[feature(fs,path,io,core,collections)\]/#![feature(fs,path,io,core,collections,slice_patterns)]/' src/lib.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
