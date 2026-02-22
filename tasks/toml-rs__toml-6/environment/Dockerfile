FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust - use 1.76 to match MSRV and avoid newer compiler errors
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.76
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/toml-rs/toml.git src && \
    cd src && \
    (git fetch --depth 1 origin 74ff531f95c87dd647a9cfa648fe787cc162c53f || git fetch --depth 1 origin "+refs/pull/6/head:refs/remotes/origin/pr/6") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for CI consistency
ENV RUST_BACKTRACE=1
ENV CARGO_TERM_COLOR=always

# Pin dependencies to compatible versions (no Cargo.lock in this old version)
RUN sed -i 's/combine = "3.0.0-alpha.2"/combine = "=3.0.0-alpha.2"/' Cargo.toml && \
    sed -i 's/toml-test-harness = "0.2"/toml-test-harness = "=0.2.0"/' Cargo.toml

# Remove #![deny(warnings)] to allow warnings on old code with new Rust
RUN sed -i '/#!\[deny(warnings)\]/d' src/lib.rs

# Fetch dependencies
RUN cargo fetch

# Build the workspace to ensure everything compiles
RUN cargo build --workspace --all-targets

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Remove #![deny(warnings)] to allow warnings on old code with new Rust
RUN sed -i '/#!\[deny(warnings)\]/d' src/lib.rs

# Rebuild after applying bug.patch
RUN cargo build --workspace --all-targets

RUN rm -rf /app/src/.git

WORKDIR /app/src
