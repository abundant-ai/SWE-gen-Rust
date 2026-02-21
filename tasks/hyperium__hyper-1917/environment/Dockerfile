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
    (git fetch --depth 1 origin d521ee2faf3aab95d08ef8bc46d1b3eed48a9c06 || git fetch --depth 1 origin "+refs/pull/1917/head:refs/remotes/origin/pr/1917") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Apply bug.patch FIRST to get buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Pin git dependencies to compatible commits from August 2019
# This commit uses git deps without commit hashes, which now pull incompatible latest versions
RUN sed -i 's|h2 = { git = "https://github.com/hyperium/h2" }|h2 = { git = "https://github.com/hyperium/h2", rev = "2d90efee1799f049528b9897c702ca83075f4cc5" }|' Cargo.toml && \
    sed -i 's|http-body = { git = "https://github.com/hyperium/http-body" }|http-body = { git = "https://github.com/hyperium/http-body", rev = "5213f59718385d36cb02d86adfeefa3a3f908be4" }|' Cargo.toml

# Fetch dependencies
RUN cargo fetch

RUN rm -rf /app/src/.git

WORKDIR /app/src
