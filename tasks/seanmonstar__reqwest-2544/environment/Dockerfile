FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages for Rust and HTTP/3 testing
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin b567ee676137b8c8af1b657e5ece9aa8d7318613 || git fetch --depth 1 origin "+refs/pull/2544/head:refs/remotes/origin/pr/2544") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables from CI config
ENV REQWEST_TEST_BODY_FULL=1
ENV RUST_BACKTRACE=1
ENV CARGO_INCREMENTAL=0
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
ENV RUSTFLAGS='--cfg reqwest_unstable'
ENV RUSTDOCFLAGS='--cfg reqwest_unstable'

# Pin quinn to 0.11.1 to match h3-quinn 0.0.7 compatibility
# h3-quinn 0.0.7 is not compatible with newer quinn 0.11.x versions
# quinn 0.11.1 requires quinn-proto ^0.11.2, so we allow proto to be latest compatible
RUN cargo update -p quinn --precise 0.11.1

# Build with http3 feature to generate Cargo.lock with compatible dependency versions
# This ensures we get the same versions that worked when the commit was made
RUN cargo build --features http3 --release || true

# Reset source code to ensure bug.patch applies cleanly
# Note: Cargo.lock is not tracked in git for this repo, so it won't be reset
RUN git reset --hard HEAD

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch


RUN rm -rf /app/src/.git

WORKDIR /app/src
