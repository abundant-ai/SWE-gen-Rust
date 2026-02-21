FROM ubuntu:24.04

# Install base system packages
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
    (git fetch --depth 1 origin c579275eb13b8a81fac5efe0b781b1ab43f8b873 || git fetch --depth 1 origin "+refs/pull/2706/head:refs/remotes/origin/pr/2706") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Fix tcp.rs compilation issue (socket2 0.4 doesn't have with_interval/with_retries methods)
RUN sed -i 's/ka.with_interval(interval)/ka/' src/server/tcp.rs && \
    sed -i 's/ka.with_retries(retries)/ka/' src/server/tcp.rs

# Build the project with full features
RUN cargo build --features full

# Reset any changes from build/fixes to ensure bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix support/mod.rs to avoid unused import error (StatusCode not used after bug.patch)
RUN sed -i 's/pub use hyper::{HeaderMap, StatusCode};/pub use hyper::HeaderMap; \/\/ StatusCode unused after bug.patch/' tests/support/mod.rs

# Fix tcp.rs compilation issue again (socket2 0.4 doesn't have with_interval/with_retries methods)
RUN sed -i 's/ka.with_interval(interval)/ka/' src/server/tcp.rs && \
    sed -i 's/ka.with_retries(retries)/ka/' src/server/tcp.rs

# Rebuild after applying bug.patch
RUN cargo build --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
