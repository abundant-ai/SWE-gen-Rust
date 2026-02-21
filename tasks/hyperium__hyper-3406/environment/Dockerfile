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
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/hyperium/hyper.git src && \
    cd src && \
    (git fetch --depth 1 origin 1ed305643c3e4fd709b12d1003934814c77fe40c || git fetch --depth 1 origin "+refs/pull/3406/head:refs/remotes/origin/pr/3406") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build the project with full features (required for tests)
RUN cargo build --features full

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix Cargo.toml to enable alloc feature for futures-util (needed for tests)
# This is a workaround for commit 1ed30564 which has http 1.0 but doesn't enable alloc
RUN sed -i 's/futures-util = { version = "0.3", default-features = false }/futures-util = { version = "0.3", default-features = false, features = ["alloc"] }/' Cargo.toml

# Note: We do NOT rebuild after applying bug.patch because the buggy code doesn't compile!
# The bug.patch removes Clone derives which are required by http 1.0,
# so the code will fail to compile until the test.sh applies the fix.

RUN rm -rf /app/src/.git

WORKDIR /app/src
