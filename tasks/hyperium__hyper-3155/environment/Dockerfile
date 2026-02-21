FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/hyperium/hyper.git src && \
    cd src && \
    (git fetch --depth 1 origin 3e08efcc4f6c1248f3ed5fd164d8c9f7068b0276 || git fetch --depth 1 origin "+refs/pull/3155/head:refs/remotes/origin/pr/3155") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build the project with full features (required for tests)
RUN cargo build --features full

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix support/mod.rs to allow unused imports (bug.patch causes StatusCode to be unused)
RUN sed -i '1i #![allow(unused)]' tests/support/mod.rs

# Rebuild after applying bug.patch
RUN cargo build --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
