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
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/BurntSushi/ripgrep.git src && \
    cd src && \
    (git fetch --depth 1 origin acca46124c04355ae78627f1c728a3feefe50f07 || git fetch --depth 1 origin "+refs/pull/520/head:refs/remotes/origin/pr/520") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix encoding_rs version incompatibility with modern Rust
# encoding_rs 0.6.11 has a syntax error; downgrade to 0.5.1 which compiles
RUN sed -i 's/encoding_rs = "0.6"/encoding_rs = "0.5.1"/' Cargo.toml

# Build after applying bug.patch
# Need to build both the binary and tests since tests invoke the binary
RUN cargo build && cargo build --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
