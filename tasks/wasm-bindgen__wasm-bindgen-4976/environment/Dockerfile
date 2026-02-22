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
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Add wasm32-unknown-unknown target for Rust
RUN rustup target add wasm32-unknown-unknown

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/wasm-bindgen/wasm-bindgen.git src && \
    cd src && \
    (git fetch --depth 1 origin d6101043a5a111dd8659a35f15ad1eb6e09b334a || git fetch --depth 1 origin "+refs/pull/4976/head:refs/remotes/origin/pr/4976") && \
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
