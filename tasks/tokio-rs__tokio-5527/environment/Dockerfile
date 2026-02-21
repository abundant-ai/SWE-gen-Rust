FROM ubuntu:24.04

# Install base system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (minimal profile to save space)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tokio-rs/tokio.git src && \
    cd src && \
    (git fetch --depth 1 origin f9f2930fcdce8b832e0baba1c1efe03c43675410 || git fetch --depth 1 origin "+refs/pull/5527/head:refs/remotes/origin/pr/5527") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV RUST_BACKTRACE=1
ENV RUSTFLAGS="--cfg tokio_unstable --cfg tokio_taskdump"

# Fetch dependencies and build workspace
RUN cargo fetch
RUN cargo build --workspace --features full

# Reset any tracked files modified during build
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build --workspace --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
