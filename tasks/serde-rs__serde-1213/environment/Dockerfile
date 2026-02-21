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
    (git fetch --depth 1 origin 629bf7b3541ee78f7c275ed68cdb34f49c60f783 || git fetch --depth 1 origin "+refs/pull/1213/head:refs/remotes/origin/pr/1213") && \
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

# Allow modern Rust lints that aren't related to the dead_code issue being tested
RUN sed -i 's|#!\[deny(warnings)\]|#![deny(warnings)]\n#![allow(non_local_definitions)]\n#![allow(mixed_script_confusables)]|' test_suite/tests/test_gen.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
