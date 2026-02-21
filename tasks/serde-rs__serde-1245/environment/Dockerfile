FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (nightly from 2024 for newer dependencies)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2024-11-01 --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/serde-rs/serde.git src && \
    cd src && \
    (git fetch --depth 1 origin aac1c65033690b2e87bf7efb5cb321d94255a5e0 || git fetch --depth 1 origin "+refs/pull/1245/head:refs/remotes/origin/pr/1245") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Reset tracked files to ensure bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix old nonzero API usage for modern Rust (comment out the deprecated import)
RUN sed -i 's|pub use core::nonzero::{NonZero, Zeroable};|// pub use core::nonzero::{NonZero, Zeroable}; // Commented for modern Rust|' serde/src/lib.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
