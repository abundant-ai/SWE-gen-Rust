FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages
RUN apt-get update && apt-get install -y \
    libclang-dev \
    cmake \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tree-sitter/tree-sitter.git src && \
    cd src && \
    (git fetch --depth 1 origin 557f1b32d0d3f22aa0cf3b616de22557eeacd2f3 || git fetch --depth 1 origin "+refs/pull/4523/head:refs/remotes/origin/pr/4523") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never

# Fetch Rust dependencies and build the project
RUN cargo fetch
RUN cargo build --release

# Fetch test grammars for corpus tests
RUN cargo xtask fetch-fixtures

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --release

# Re-fetch fixtures after rebuild
RUN cargo xtask fetch-fixtures

RUN rm -rf /app/src/.git

WORKDIR /app/src
