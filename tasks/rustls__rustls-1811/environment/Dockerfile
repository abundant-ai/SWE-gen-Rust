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
    cmake \
    golang \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rustls/rustls.git src && \
    cd src && \
    (git fetch --depth 1 origin 6d7569e09c0366412a969d1995c94ec1cbb6fec1 || git fetch --depth 1 origin "+refs/pull/1811/head:refs/remotes/origin/pr/1811") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Install dependencies (fetch crates)
RUN cargo fetch

# Reset to clean state so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
