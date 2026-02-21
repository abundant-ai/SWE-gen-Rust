FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust with nightly from around the PR date (Jan 2025)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2025-01-10
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/serde-rs/serde.git src && \
    cd src && \
    (git fetch --depth 1 origin 4036ff88edc2ee85f288e8c9bc6d9a0f393cf96e || git fetch --depth 1 origin "+refs/pull/2802/head:refs/remotes/origin/pr/2802") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust
ENV RUSTFLAGS="-Dwarnings"

# Remove trybuild dependency which has trait conflicts with [patch.crates-io]
RUN sed -i '/trybuild/d; /automod/d; /rustversion/d' test_suite/Cargo.toml && \
    rm -f test_suite/tests/compiletest.rs

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
