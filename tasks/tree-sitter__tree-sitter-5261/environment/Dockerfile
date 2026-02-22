FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages needed for tree-sitter
RUN apt-get update && apt-get install -y \
    libclang-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for JavaScript grammar tests)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tree-sitter/tree-sitter.git src && \
    cd src && \
    (git fetch --depth 1 origin b714e2a7c01e8d5abab526f23e40b77c33babcb4 || git fetch --depth 1 origin "+refs/pull/5261/head:refs/remotes/origin/pr/5261") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never

# Fetch dependencies and build the project
RUN cargo fetch
RUN cargo build --release

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for Rust)
RUN cargo build --release

# Clone test grammars needed for parser tests
RUN mkdir -p test/fixtures/grammars && \
    cd test/fixtures/grammars && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-javascript.git javascript && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-jsdoc.git jsdoc && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-html.git html && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-embedded-template.git embedded-template && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-rust.git rust && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-json.git json && \
    git clone --depth 1 https://github.com/tree-sitter/tree-sitter-python.git python

RUN rm -rf /app/src/.git

WORKDIR /app/src
