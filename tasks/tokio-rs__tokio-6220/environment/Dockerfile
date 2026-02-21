FROM ubuntu:24.04

# Base system packages (common to all languages)
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
    (git fetch --depth 1 origin d32ea4d3a7ff525b8477411f9bf7d59e06dc6ede || git fetch --depth 1 origin "+refs/pull/6220/head:refs/remotes/origin/pr/6220") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV RUST_BACKTRACE=1

# Fetch dependencies and build workspace
RUN cargo fetch
RUN cargo build --workspace --features full

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Note: Cannot rebuild after bug.patch because it creates an incomplete Cargo.lock
# that causes build failures. The tests will apply fix.patch which restores it.

RUN rm -rf /app/src/.git

WORKDIR /app/src
