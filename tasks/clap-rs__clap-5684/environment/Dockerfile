FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (using version 1.92 for derive_ui tests)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.92
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/clap-rs/clap.git src && \
    cd src && \
    (git fetch --depth 1 origin 0209a79031cc96fde273cc09ef194d93bb68f8fa || git fetch --depth 1 origin "+refs/pull/5684/head:refs/remotes/origin/pr/5684") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never
ENV RUST_BACKTRACE=1

# Fetch dependencies
RUN cargo fetch

# Build the project (clap_complete tests require unstable-dynamic and unstable-command features)
RUN cargo build --package clap_complete --tests --features unstable-dynamic,unstable-command

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (clap_complete tests require unstable-dynamic and unstable-command features)
RUN cargo build --package clap_complete --tests --features unstable-dynamic,unstable-command

RUN rm -rf /app/src/.git

WORKDIR /app/src
