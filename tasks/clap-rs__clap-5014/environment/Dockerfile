FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using version 1.92 for derive_ui tests)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/clap-rs/clap.git src && \
    cd src && \
    (git fetch --depth 1 origin bc000aa4b0f6869a9a4a0a9b6f5bbf636d3559bd || git fetch --depth 1 origin "+refs/pull/5014/head:refs/remotes/origin/pr/5014") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never
ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Build tests after applying bug.patch with wrap_help and unstable-v5 features
RUN cargo build --tests --features "wrap_help,unstable-v5"

RUN rm -rf /app/src/.git

WORKDIR /app/src
