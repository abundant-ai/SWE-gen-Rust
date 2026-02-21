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
    (git fetch --depth 1 origin 2fe85ca9623f47f4efab2f8b25bc0ef9ccbe307c || git fetch --depth 1 origin "+refs/pull/2473/head:refs/remotes/origin/pr/2473") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Fix sync_wrapper.rs invalid doc attributes
RUN sed -i '/^#!\[doc(html_logo_url/d' src/common/sync_wrapper.rs && \
    sed -i '/^#!\[doc(html_favicon_url/d' src/common/sync_wrapper.rs

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

# Fix sync_wrapper.rs invalid doc attributes again
RUN sed -i '/^#!\[doc(html_logo_url/d' src/common/sync_wrapper.rs && \
    sed -i '/^#!\[doc(html_favicon_url/d' src/common/sync_wrapper.rs

# Fix tcp.rs compilation issue again (socket2 0.4 doesn't have with_interval/with_retries methods)
RUN sed -i 's/ka.with_interval(interval)/ka/' src/server/tcp.rs && \
    sed -i 's/ka.with_retries(retries)/ka/' src/server/tcp.rs

# Rebuild after applying bug.patch
RUN cargo build --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
