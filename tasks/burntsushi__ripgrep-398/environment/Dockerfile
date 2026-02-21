FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (use 1.23 from late 2017, works with this codebase and before strict mem::uninitialized checks)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.23.0
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/BurntSushi/ripgrep.git src && \
    cd src && \
    (git fetch --depth 1 origin 92f1422759205e44489a43b01c6dad152a8ba135 || git fetch --depth 1 origin "+refs/pull/398/head:refs/remotes/origin/pr/398") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for Rust builds
ENV RUST_BACKTRACE=1

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Build after applying bug.patch
# Need to build both the binary and tests since tests invoke the binary
RUN cargo build && cargo build --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
