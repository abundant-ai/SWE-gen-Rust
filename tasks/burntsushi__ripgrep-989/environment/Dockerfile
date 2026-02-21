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
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.85.0
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/BurntSushi/ripgrep.git src && \
    cd src && \
    (git fetch --depth 1 origin e09265e22dbf607114e79ed3703057c0d4587fd8 || git fetch --depth 1 origin "+refs/pull/989/head:refs/remotes/origin/pr/989") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1

# Apply bug.patch to revert to buggy state (BASE)
# Note: Cargo.lock hunks may fail due to checksum changes, but we regenerate it below
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch || (echo "Patch had failures (likely Cargo.lock), continuing..." && test -f src/app.rs) && rm /tmp/bug.patch

# Regenerate Cargo.lock based on the updated Cargo.toml dependencies
RUN rm -f Cargo.lock && cargo generate-lockfile

# Build after applying bug.patch
RUN cargo build --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
