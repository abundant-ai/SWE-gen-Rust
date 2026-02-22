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

# Install Node.js (required for wasm-bindgen tests)
# Using Node.js 22 because playwright.spec.ts uses globSync from node:fs (added in v22)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Add wasm32-unknown-unknown target for Rust
RUN rustup target add wasm32-unknown-unknown

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/wasm-bindgen/wasm-bindgen.git src && \
    cd src && \
    (git fetch --depth 1 origin a7edd1298e0eceb1be0e798a226fcfea41237e57 || git fetch --depth 1 origin "+refs/pull/4731/head:refs/remotes/origin/pr/4731") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust
ENV CARGO_TERM_COLOR=never

# Fetch dependencies
RUN cargo fetch

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo fetch

RUN rm -rf /app/src/.git

WORKDIR /app/src
